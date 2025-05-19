module NVPL

# using NVPL_jll

# Without NVPL_jll, we have to load manually
include("localSupport.jl")

using LinearAlgebra, Logging

@enum Threading begin
    THREADING_SEQUENTIAL
    THREADING_GNU
end

# Consider adding service APIs
# - https://docs.nvidia.com/nvpl/latest/blas/api/service.html
# - https://docs.nvidia.com/nvpl/latest/lapack/api/service.html

function __init__()
    lbt_forward_to_nvpl()
end

function lbt_forward_to_nvpl(; layer::Threading = THREADING_GNU)
    if !NVPL_jll.is_available()
        isinteractive() && @warn "NVPL is not available/installed."
        return
    end

    if layer == THREADING_GNU
        if Base.USE_BLAS64
            # Load ILP64 BLAS forwards
            BLAS.lbt_forward(libnvpl_blas_ilp64_gomp; clear=true, suffix_hint="")
            # Load ILP64 LAPACK forwards
            BLAS.lbt_forward(libnvpl_lapack_ilp64_gomp; clear=false, suffix_hint="")
        else
            # Load LP64 BLAS forwards
            BLAS.lbt_forward(libnvpl_blas_lp64_gomp; clear=true, suffix_hint="")
            # Load LP64 LAPACK forwards
            BLAS.lbt_forward(libnvpl_lapack_lp64_gomp; clear=false, suffix_hint="")
        end
    elseif layer == THREADING_SEQUENTIAL
        if Base.USE_BLAS64
            # Load ILP64 BLAS forwards
            BLAS.lbt_forward(libnvpl_blas_ilp64_seq; clear=true, suffix_hint="")
            # Load ILP64 LAPACK forwards
            BLAS.lbt_forward(libnvpl_lapack_ilp64_seq; clear=false, suffix_hint="")
        else
            # Load LP64 BLAS forwards
            BLAS.lbt_forward(libnvpl_blas_lp64_seq; clear=true, suffix_hint="")
            # Load LP64 LAPACK forwards
            BLAS.lbt_forward(libnvpl_lapack_lp64_seq; clear=false, suffix_hint="")
        end
    else
        isinteractive() && @warn "Unsupported NVPL threading layer: $layer"
        return
    end
end

end # module
