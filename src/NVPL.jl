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

for lib in ("blas", "lapack")
    @eval begin
        function $(Symbol("$lib","_get_version"))()::VersionNumber
            _nvpl_int_to_version(ccall(($(string("nvpl_","$lib","_get_version")), $(Symbol("_libnvpl_","$lib","_path"))[]), Cint, ()))
        end

        function $(Symbol("$lib","_get_max_threads"))()::Int
            Int(ccall(($(string("nvpl_","$lib","_get_max_threads")), $(Symbol("_libnvpl_","$lib","_path"))[]), Cint, ()))
        end

        function $(Symbol("$lib","_set_num_threads"))(nthr::Int)
            ccall(($(string("nvpl_","$lib","_set_num_threads")), $(Symbol("_libnvpl_","$lib","_path"))[]), Cvoid, (Ref{Cint},), Cint(nthr))
        end

        function $(Symbol("$lib","_set_num_threads_local"))(nthr_local::Int)
            ccall(($(string("nvpl_","$lib","_set_num_threads_local")), $(Symbol("_libnvpl_","$lib","_path"))[]), Cvoid, (Ref{Cint},), Cint(nthr_local))
        end
    end
end

function __init__()
    lbt_forward_to_nvpl()
end

function lbt_forward_to_nvpl(; layer::Threading = THREADING_GNU)
    if !NVPL_jll.is_available()
        isinteractive() && @warn "NVPL is not available/installed."
        return
    end

    # Use OpenBLAS for sgemmt and dgemmt
    BLAS.lbt_forward(OpenBLAS_jll.libopenblas_path; clear=true)

    # Determine threading layer and int type
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

    # Load BLAS forwards
    BLAS.lbt_forward(_libnvpl_blas_path[]; clear=false)
    # Load LAPACK forwards
    BLAS.lbt_forward(_libnvpl_lapack_path[]; clear=false)
end

end # module
