module NVPL

# using NVPL_jll
using OpenBLAS_jll

# Without NVPL_jll, we have to load manually
include("localSupport.jl")

using LinearAlgebra, Logging

@enum Threading begin
    THREADING_SEQUENTIAL
    THREADING_GNU
end

const _libnvpl_blas_path = Ref{String}()
const _libnvpl_lapack_path = Ref{String}()

_nvpl_int_to_version(v::Cint) = VersionNumber(v ÷ 10000, (v % 10000) ÷ 100, v % 100)

include("libnvpl_blas_api.jl")
include("libnvpl_lapack_api.jl")

function __init__()
    lbt_forward_to_nvpl()
end

# Note: LAPACK is disabled by default. As NVIDIA writes: 
#   "As the current release of NVPL LAPACK has a limited scope of optimizations,
#   some of the admittedly important routines have not been optimized yet."
#     -- source: https://docs.nvidia.com/nvpl/latest/lapack/api/overview.html
# In limited tests on Grace, NVPL LAPACK seems to be significantly slower than OpenBLAS LAPACK.
function lbt_forward_to_nvpl(; layer::Threading = THREADING_GNU, lapack=false)::Nothing
    if !NVPL_jll.is_available()
        isinteractive() && @warn "NVPL is not available/installed."
        return
    end

    # Use OpenBLAS for sgemmt and dgemmt
    BLAS.lbt_forward(OpenBLAS_jll.libopenblas_path; clear=true)

    # Determine threading layer and int type
    # Note: separate BLAS/LAPACK threading layers seem to work as well...
    if layer == THREADING_GNU
        if Base.USE_BLAS64
            _libnvpl_blas_path[] = libnvpl_blas_ilp64_gomp
            _libnvpl_lapack_path[] = libnvpl_lapack_ilp64_gomp
        else
            _libnvpl_blas_path[] = libnvpl_blas_lp64_gomp
            _libnvpl_lapack_path[] = libnvpl_lapack_lp64_gomp
        end
    elseif layer == THREADING_SEQUENTIAL
        if Base.USE_BLAS64
            _libnvpl_blas_path[] = libnvpl_blas_ilp64_seq
            _libnvpl_lapack_path[] = libnvpl_lapack_ilp64_seq
        else
            _libnvpl_blas_path[] = libnvpl_blas_lp64_seq
            _libnvpl_lapack_path[] = libnvpl_lapack_lp64_seq
        end
    else
        isinteractive() && @warn "Unsupported NVPL threading layer: $layer"
        return
    end

    # Load LAPACK forwards
    # Note: loading later would overshadow the BLAS forwards.
    # Not much of a difference right now, but relevant in case we decide
    # to allow separate threading layers for LAPACK and BLAS.
    lapack && BLAS.lbt_forward(_libnvpl_lapack_path[]; clear=false)
    # Load BLAS forwards
    BLAS.lbt_forward(_libnvpl_blas_path[]; clear=false)

    return nothing
end

end # module
