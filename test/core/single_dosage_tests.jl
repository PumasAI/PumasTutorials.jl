using Pumas, Test, CSV, Random

# Read the data
data = read_pumas(example_data("data1"),
                  cvs = [:sex,:wt,:etn])

# Cut off the `t=0` pre-dose observation as it throws conditional_nll calculations
# off the scale (variance of the simulated distribution is too small).
for subject in data
  if subject.time[1] == 0
    popfirst!(subject.time)
    popfirst!(subject.observations.dv)
  end
end

# Definition using diffeqs
m_diffeq = @model begin
  @param begin
    θ ∈ VectorDomain(4, lower=zeros(4), init=ones(4))
    Ω ∈ PSDDomain(2)
    σ ∈ RealDomain(lower=0.0, init=1.0)
  end

  @random begin
    η ~ MvNormal(Ω)
  end

  @covariates sex wt etn

  @pre begin
    Ka = θ[1]
    CL = θ[2] * ((wt/70)^0.75) * (θ[4]^sex) * exp(η[1])
    Vc = θ[3] * exp(η[2])
  end

  @vars begin
    cp = Central/Vc
  end

  @dynamics begin
    Depot'   = -Ka*Depot
    Central' =  Ka*Depot - CL*cp
  end

  @derived begin
    conc = @. Central / Vc
    dv ~ @. Normal(conc, conc*σ)
  end
end

# Definition using analytic models
m_analytic = @model begin
  @param begin
    θ ∈ VectorDomain(4, lower=zeros(4), init=ones(4))
    Ω ∈ PSDDomain(2)
    σ ∈ RealDomain(lower=0.0, init=1.0)
  end

  @random begin
    η ~ MvNormal(Ω)
  end

  @covariates sex wt etn

  @pre begin
    Ka = θ[1]
    CL = θ[2] * ((wt/70)^0.75) * (θ[4]^sex) * exp(η[1])
    Vc = θ[3] * exp(η[2])
  end

  @dynamics Depots1Central1

  @derived begin
    conc = @. Central / Vc
    dv ~ @. Normal(conc, conc*σ)
  end
end

# Define the ODE
param = (θ = [2.268,74.17,468.6,0.5876],
         Ω = [0.05 0.0;
              0.0  0.2],
         σ = 0.1)

subject1 = data[1]

randeffs = init_randeffs(m_diffeq, param)

sol_diffeq   = solve(m_diffeq, subject1, param, randeffs)
sol_analytic = solve(m_analytic, subject1, param, randeffs)

@test sol_diffeq(1.0) ≈ sol_analytic(1.0) rtol=1e-4

sol_diffeq = solve(m_diffeq, subject1, param, randeffs, alg=Rosenbrock23())

@test sol_diffeq.alg == Rosenbrock23()

@test conditional_nll(m_diffeq, subject1, param, randeffs) ≈ conditional_nll(m_analytic, subject1, param, randeffs) rtol=1e-3

sim_diffeq = begin
  Random.seed!(1)
  s = simobs(m_diffeq, subject1, param, randeffs)[:dv]
end
sim_analytic = begin
  Random.seed!(1)
  s = simobs(m_analytic, subject1, param, randeffs)[:dv]
end
@test sim_diffeq ≈ sim_analytic rtol=1e-4

sim_diffeq = begin
  Random.seed!(1)
  s = simobs(m_diffeq, subject1, param)[:dv]
end
sim_analytic = begin
  Random.seed!(1)
  s = simobs(m_analytic, subject1, param)[:dv]
end
@test sim_diffeq ≈ sim_analytic rtol=1e-4

sol_diffeq = solve(m_diffeq, data, param, ensemblealg = EnsembleSerial())
sol_diffeq = solve(m_diffeq, data, param, ensemblealg = EnsembleThreads())
sol_diffeq = solve(m_diffeq, data, param, ensemblealg = EnsembleSplitThreads())
sol_diffeq = solve(m_diffeq, data, param, ensemblealg = EnsembleDistributed())

sol_diffeq = simobs(m_diffeq, data, param, ensemblealg = EnsembleSerial())
sol_diffeq = simobs(m_diffeq, data, param, ensemblealg = EnsembleThreads())
sol_diffeq = simobs(m_diffeq, data, param, ensemblealg = EnsembleSplitThreads())
sol_diffeq = simobs(m_diffeq, data, param, ensemblealg = EnsembleDistributed())

@testset "placebo subject (without events)" begin
  placebo_subject = deepcopy(subject1)
  placebo_subject.observations.dv .= missing
  empty!(placebo_subject.events)

  s_diffeq   = solve(m_diffeq, placebo_subject, param, randeffs)
  s_analytic = solve(m_analytic, placebo_subject, param, randeffs)

  @test s_diffeq(10.0)[:Central] == s_analytic(10.0)[:Central]
end
