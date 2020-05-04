using Pumas, Test, Distributions

# Load data
cvs = [:ka, :cl, :v]
dvs = [:dv]
data = read_pumas(example_data("oral1_1cpt_KAVCL_MD_data"),
                      cvs =  cvs , dvs = dvs)

m_diffeq = @model begin

    @covariates ka cl v

    @pre begin
        Ka = ka
        CL = cl
        Vc  = v
    end

    @vars begin
        cp = Central / Vc
    end

    @dynamics begin
        Depot'   = -Ka*Depot
        Central' =  Ka*Depot - CL*cp
    end

    @derived begin
        conc = @. Central / Vc
        dv ~ @. Normal(conc, 1e-100)
    end
end

m_analytic = @model begin

    @covariates ka cl v

    @pre begin
        Ka = ka
        CL = cl
        Vc  = v
    end
    @dynamics Depots1Central1 

    @derived begin
        conc = @. Central / Vc
        dv ~ @. Normal(conc, 1e-100)
    end
end

@test_broken @inferred solve(m_analytic,data[1],(),())
@test_broken @inferred simobs(m_analytic,data[1],(),())
@test_broken @inferred simobs(m_analytic,data[1],(),())

# inference broken in both `modify_pkpd_problem` and `solve`
@test_broken @inferred solve(m_diffeq,data[1],(),())
@test_broken @inferred simobs(m_analytic,data[1],(),())
@test_broken @inferred simobs(m_diffeq,data[1],(),())
