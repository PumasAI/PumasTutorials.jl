using PKPDSimulator, Base.Test, NamedTuples, DelayDiffEq

θ = [
     1.5,  #Ka
     1.0,  #CL
     30.0 #V
     ]

params = ParamSet(@NT(θ=VectorDomain(3, lower=zeros(4),init=θ), Ω=PSDDomain(2)))
function randomfx(p)
  RandomEffectSet(@NT(η=RandomEffect(MvNormal(p.Ω))))
end

function collate(params, randoms, covars)
    θ = params.θ
    η = randoms.η
    @NT(Ka = θ[1],
        CL = θ[2]*exp(η[1]),
        V  = θ[3]*exp(η[2]))
end

function f(du,u,h,p,t)
  Depot,Central = u
  du[1] = -p.Ka*Depot
  du[2] =  p.Ka*Depot - (p.CL/p.V)*Central - 0.1h(t-1,Val{0},2)
end
h(t,idxs=0) = 0.0
prob = DDEProblem(f,h,zeros(2),(0.0,72.0),[1])

function err(params, randoms, covars, u,p, t)
    V = p.V
    Depot, Central = u
    Σ = params.Σ
    conc = Central / V
    @NT(dv=Normal(conc, conc*Σ))
end

init = (_param, _random, _data_cov,_collate,t) -> [0.0,0.0]
post = (_param, _random, _data_cov,_collate,_odevars,t) -> @NT(conc = _odevars[2] / _collate.V)
model = PKPDSimulator.PKPDModel(params,randomfx,collate,init,prob,post,err)

x0 = init_param(model)
y0 = init_random(model, x0)
subject = data

data = build_dataset(amt=[10,20], ii=[24,24], addl=[2,2], ss=[0,0], time=[0,12],  cmt=[1,1])
sol  = pkpd_solve(model,data,x0,y0,MethodOfSteps(Tsit5()))

#data = build_dataset(amt=[10,20], ii=[24,24], addl=[2,2], ss=[1,2], time=[0,12],  cmt=[2,2])
#sol  = simulate(pkpd,θ,η,data,MethodOfSteps(Tsit5()))
