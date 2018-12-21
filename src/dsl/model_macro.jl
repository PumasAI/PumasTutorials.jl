using DataStructures
using MacroTools
using ModelingToolkit

islinenum(x) = x isa LineNumberNode
function nt_expr(set, prefix=nothing)
  t = :(())
  for p in set
    sym = prefix === nothing ? p : Symbol(prefix, p)
    push!(t.args, :($p = $sym))
  end
  t
end
function nt_expr(dict::AbstractDict, prefix=nothing)
  t = :(())
  for (p,d) in pairs(dict)
    sym = prefix === nothing ? d : Symbol(prefix, d)
    push!(t.args, :($p = $sym))
  end
  t
end

function var_def(tupvar, indvars)
  quote
    if $tupvar != nothing
      if $tupvar isa NamedTuple
        # Allow for NamedTuples to be in different order
        $(Expr(:block, [:($(esc(v)) = $tupvar.$v) for v in indvars]...))
      else
        $(Expr(:tuple, (esc(v) for v in indvars)...)) = $tupvar
      end
    end
  end
end
var_def(tupvar, inddict::AbstractDict) = var_def(tupvar, keys(inddict))


function extract_params!(vars, params, exprs)
  # should be called on an expression wrapped in a @param
  # expr can be:
  #  a block
  #  a constant expression
  #    a = 1
  #  a domain
  #    a ∈ RealDomain()
  #  a random variable 
  #    a ~ Normal()
  if exprs isa Expr && exprs.head == :block
    _exprs = exprs.args
  else
    _exprs = (exprs,)
  end

  for expr in _exprs
    expr isa LineNumberNode && continue
    @assert expr isa Expr
    if expr.head == :call && expr.args[1] in (:∈, :in)
      p = expr.args[2]
      p in vars && error("Variable $p already defined")
      push!(vars,p)
      params[p] = expr.args[3]
    elseif expr.head == :(=)
      p = expr.args[1]
      p in vars && error("Variable $p already defined")
      push!(vars,p)
      params[p] = :(ConstDomain($(expr.args[2])))
    elseif expr.head == :call && expr.args[1] == :~
      p = expr.args[2]
      p in vars && error("Variable $p already defined")
      push!(vars,p)
      params[p] = expr.args[3]
    else
      error("Invalid @param expression: $expr")
    end
  end
end

function param_obj(params)
  :(ParamSet($(esc(nt_expr(params)))))
end

function extract_randoms!(vars, randoms, exprs)
  # should be called on an expression wrapped in a @random
  # expr can be:
  #  a block
  #  a constant expression
  #    a = 1
  #  a random var
  #    a ~ Normal(0,1)

  if exprs isa Expr && exprs.head == :block
    _exprs = exprs.args
  else
    _exprs = (exprs,)
  end

  for expr in _exprs
    expr isa LineNumberNode && continue
    @assert expr isa Expr
    if expr.head == :call && expr.args[1] == :~
      p = expr.args[2]
      p in vars && error("Variable $p already defined")
      push!(vars,p)
      randoms[p] = expr.args[3]
      # TODO support const expressions
      # elseif expr.head == :(=)
      #     p = expr.args[1]
      #     p in vars && error("Variable $p already defined")
      #     push!(vars,p)
      #     randoms[p] = :(ConstDomain($(expr.args[2])))
    else
      error("Invalid @random expression: $expr")
    end
  end
end

function random_obj(randoms, params)
  quote
    function (_param)
      $(var_def(:_param, params))
      ParamSet($(esc(nt_expr(randoms))))
    end
  end
end

function extract_syms!(vars, subvars, syms)
  for p in syms
    p isa LineNumberNode && continue
    p in vars && error("Variable $p already defined")
    push!(subvars, p)
    push!(vars, p)
  end
end

function extract_pre!(vars, prevars, exprs)
  # should be called on an expression wrapped in a @pre
  # expr can be:
  #  a block
  #  an assignment
  #    a = 1

  if exprs isa Expr && exprs.head == :block
    _exprs = exprs.args
  else
    _exprs = (exprs,)
  end

  newexpr = Expr(:block)
  for expr in _exprs
    MacroTools.prewalk(expr) do ex
      if ex isa Expr && ((iseq = ex.head == :(=)) || ex.head == :(:=)) && length(ex.args) == 2
        p = ex.args[1]
        p in vars && error("Variable $p already defined")
        if iseq
          push!(vars, p)
          push!(prevars, p)
        end
        push!(newexpr.args, :($p = $(ex.args[2])))
      else
        ex
      end
    end
  end
  newexpr
end

function pre_obj(preexpr, prevars, params, randoms, covariates)
  quote
    function (_param, _random, _covariates)
      $(var_def(:_param, params))
      $(var_def(:_random, randoms))
      $(var_def(:_covariates, covariates))
      $(esc(preexpr))
      $(esc(nt_expr(prevars)))
    end
  end
end


function extract_dynamics!(vars, odevars, ode_init, expr::Expr, eqs)
  if expr.head == :block
    for ex in expr.args
      islinenum(ex) && continue
      extract_dynamics!(vars, odevars, ode_init, ex, eqs)
    end
  elseif expr.head == :(=) || expr.head == :(:=)
    # `odevars[1]` stores DVar & `odevars[2]` stores Var
    dp = expr.args[1]
    isder = dp isa Expr && dp.head == Symbol('\'')
    #dp in vars && error("Variable $dp already defined")
    (isder && length(dp.args) != 1) ||
    (!isder && !isa(dp, Symbol)) &&
    error("Invalid variable $dp: must be in the form of X' or X")
    p = isder ? dp.args[1] : dp
    _odevars = isder ? odevars[1] : odevars[2]
    lhs = isder ? :(___D*$p) : p
    push!(eqs.args, :($lhs ~ $(expr.args[2])))
    if p in keys(ode_init)
      push!(_odevars, p)
    elseif p ∉ vars
      push!(vars,p)
      push!(_odevars, p)
      ode_init[p] = 0.0
    end
  else
    error("Invalid @dynamics expression: $expr")
  end
  return true # isstatic
end

# used for pre-defined analytical systems
function extract_dynamics!(vars, odevars, ode_init, sym::Symbol, eqs)
  obj = eval(sym)
  odevars = odevars[1]
  if obj isa Type && obj <: ExplicitModel # explict model
    for p in varnames(obj)
      if p in keys(ode_init)
        push!(odevars, p)
      else
        if p ∉ vars
          push!(vars,p)
          push!(odevars, p)
        end
        ode_init[p] = 0
      end
    end
    return true # isstatic
  else
    # we assume they are defined in @init
    for p in keys(ode_init)
      push!(odevars, p)
    end
    return false # isstatic
  end
end

function init_obj(ode_init,odevars,prevars,isstatic)
  if isstatic
    vecexpr = []
    for p in odevars
      push!(vecexpr, ode_init[p])
    end
    uType = SLArray{Tuple{length(odevars)},1,(odevars...,)}
    typeexpr = :($uType())
    append!(typeexpr.args,vecexpr)
    quote
      function (_pre,t)
        $(var_def(:_pre, prevars))
        $(esc(typeexpr))
      end
    end
  else
    vecexpr = :([])
    for p in odevars
      push!(vecexpr.args, ode_init[p])
    end
    quote
      function (_pre,t)
        $(var_def(:_pre, prevars))
        $(esc(vecexpr))
      end
    end
  end
end

function dynamics_obj(odeexpr::Expr, pre, odevars, eqs, isstatic)
  odeexpr == :() && return nothing
  ivar  = :(@IVar t)
  var   = :(@Var)
  dvar  = :(@DVar)
  der   = :(@Deriv ___D'~t)
  param = :(@Param)
  if isstatic
    diffeq= :(ODEProblem(ODEFunction(DiffEqSystem($eqs, [t], [], Variable[], []),version=ModelingToolkit.SArrayFunction),nothing,nothing,nothing))
  else
    diffeq= :(ODEProblem(ODEFunction(DiffEqSystem($eqs, [t], [], Variable[],
                                                  [])),nothing,nothing,nothing))
  end

  # DVar
  for v in odevars[1]
    push!(dvar.args, :($v(t)))
    push!(diffeq.args[2].args[2].args[4].args, v)
  end
  # Var
  for v in odevars[2]
    push!(var.args, v)
    push!(diffeq.args[2].args[2].args[5].args, v)
  end
  # Param
  for p in pre
    push!(param.args, p)
    push!(diffeq.args[2].args[2].args[6].args, p)
  end
  quote
    let
      $ivar
      $var
      $dvar
      $der
      $param
      $diffeq
    end
  end
end
function dynamics_obj(odename::Symbol, pre, odevars, eqs, isstatic)
  quote
    ($odename isa Type && $odename <: ExplicitModel) ? $odename() : $odename
  end
end


function extract_defs!(vars, defsdict, exprs)
  # should be called on an expression wrapped in a @derived
  # expr can be:
  #  a block
  #  an assignment
  #    a = 1

  if exprs isa Expr && exprs.head == :block
    _exprs = exprs.args
  else
    _exprs = (exprs,)
  end

  for expr in _exprs
    expr isa LineNumberNode && continue
    @assert expr isa Expr
    if expr.head == :(=)
      p = expr.args[1]
      p in vars && error("Variable $p already defined")
      push!(vars,p)
      defsdict[p] = expr.args[2]
    else
      error("Invalid expression: $expr")
    end
  end
end

function extract_randvars!(vars, randvars, distvars, postexpr, expr)
  @assert expr isa Expr
  if expr.head == :block
    for ex in expr.args
      islinenum(ex) && continue
      extract_randvars!(vars, randvars, distvars, postexpr, ex)
    end
  elseif ((iseq = expr.head == :(=)) || expr.head == :(:=)) && length(expr.args) == 2
    p = expr.args[1]
    if p ∉ vars && iseq
      push!(vars,p)
      push!(randvars,p)
    end
    push!(postexpr.args, :($p = $(expr.args[2])))
  elseif expr isa Expr && expr.head == :call && expr.args[1] == :~ && length(expr.args) == 3
    if !isempty(expr.args[3].args)
      _sym = expr.args[2]
      push!(distvars, _sym)
      sym = Symbol(:___, _sym)
      # sample distribution
      expr.args[3] = :(rand.(begin
                               $sym = $(expr.args[3])
                             end))
    end
    p = expr.args[2]
    if p ∉ vars
      push!(vars,p)
      push!(randvars,p)
    end
    push!(postexpr.args, :($p = $(expr.args[3])))
  else
    error("Invalid expression: $expr")
  end
end

function broadcasted_vars(vars)
  if !isempty(vars)
    for ex in first(vars).args
      ex isa LineNumberNode && continue
      ex.args[2] = :(@. $(ex.args[2]))
    end
  end
  vars
end

function bvar_def(collection, indvars)
  quote
    if $collection isa DataFrame
      $(Expr(:block, [:($(esc(v)) = $collection.$v) for v in indvars]...))
    else eltype($collection) <: SArray
      $(Expr(:block, [:($(esc(v)) = map(x -> x[$i], $collection)) for (i,v) in enumerate(indvars)]...))
      #else
      #$(Expr(:block, [:($(esc(v)) = map(x -> x.$v, $collection)) for v in indvars]...))
    end
  end
end

function derived_obj(derivedexpr, derivedvars, pre, odevars, distvars)
  quote
    function (_pre,_sol,_obstimes)
      $(var_def(:_pre, pre))
      if _sol != nothing
        $(bvar_def(:(_sol), odevars))
      end
      $(esc(:t)) = _obstimes
      $(esc(derivedexpr))
      $(esc(nt_expr(derivedvars))), $(esc(nt_expr(distvars, :___)))
    end
  end
end

macro model(expr)

  vars = Set{Symbol}([:t]) # t is the only reserved symbol
  params = OrderedDict{Symbol, Any}()
  randoms = OrderedDict{Symbol, Any}()
  distvars = OrderedSet{Symbol}()
  covariates = OrderedSet{Symbol}()
  prevars  = OrderedSet{Symbol}()
  ode_init  = OrderedDict{Symbol, Any}()
  odevars  = [OrderedSet{Symbol}(),OrderedSet{Symbol}()]
  preexpr = :()
  derivedvars = OrderedSet{Symbol}()
  eqs = Expr(:vect)
  vars_ = Expr[]
  derivedvars = OrderedSet{Symbol}()
  derivedexpr = Expr(:block)
  local vars, params, randoms, covariates, prevars, preexpr, odeexpr, odevars, ode_init, eqs, derivedexpr, derivedvars, isstatic, distvars

  isstatic = true
  odeexpr = :()
  lnndict = Dict{Symbol,LineNumberNode}()
  for (i,ex) in enumerate(expr.args)

    if ex isa LineNumberNode
      continue
    end
    @assert ex isa Expr && ex.head == :macrocall
    if ex.args[1] == Symbol("@param")
      extract_params!(vars, params, ex.args[3])
    elseif ex.args[1] == Symbol("@random")
      extract_randoms!(vars, randoms, ex.args[3])
    elseif ex.args[1] == Symbol("@covariates")
      extract_syms!(vars, covariates, ex.args[3:end])
    elseif ex.args[1] == Symbol("@pre")
      preexpr = extract_pre!(vars,prevars,ex.args[3])
    elseif ex.args[1] == Symbol("@vars")
      vars_ = ex.args[3:end]
    elseif ex.args[1] == Symbol("@init")
      # Add in @vars
      ex.args[3].args = [ex.args[3].args[1],copy(vars_)...,ex.args[3].args[2:end]...]
      extract_defs!(vars,ode_init, ex.args[3])
    elseif ex.args[1] == Symbol("@dynamics")
      # Add in @vars only if not an analytical solution
      if !(typeof(ex.args[3]) <: Symbol)
        ex.args[3].args = [ex.args[3].args[1],copy(vars_)...,ex.args[3].args[2:end]...]
      end
      isstatic = extract_dynamics!(vars, odevars, ode_init, ex.args[3], eqs)
      odeexpr = ex.args[3]
    elseif ex.args[1] == Symbol("@derived")
      # Add in @vars
      bvars = broadcasted_vars(copy(vars_))
      ex.args[3].args = [ex.args[3].args[1],bvars...,ex.args[3].args[2:end]...]
      extract_randvars!(vars, derivedvars, distvars, derivedexpr, ex.args[3])
    else
      error("Invalid macro $(ex.args[1])")
    end
    #return nothing
  end

  prevars = union(prevars, keys(params), keys(randoms), covariates)

  ex = quote
    x = PKPDModel(
    $(param_obj(params)),
    $(random_obj(randoms,params)),
    $(pre_obj(preexpr,prevars,params,randoms,covariates)),
    $(init_obj(ode_init,odevars[1],prevars,isstatic)),
    $(dynamics_obj(odeexpr,prevars,odevars,eqs,isstatic)),
    $(derived_obj(derivedexpr,derivedvars,prevars,odevars[1],distvars)))
    function Base.show(io::IO, ::typeof(x))
      println(io,"PKPDModel")
      println(io,"  Parameters: ",$(join(keys(params),", ")))
      println(io,"  Random effects: ",$(join(keys(randoms),", ")))
      println(io,"  Covariates: ",$(join(covariates,", ")))
      println(io,"  Dynamical variables: ",$(join(odevars[1],", ")))
      println(io,"  Derived: ",$(join(derivedvars,", ")))
    end
    x
  end
  ex.args[1] = __source__
  ex
end