using Libdl
push!(DL_LOAD_PATH, abspath("/opt/nvidia/hpc_sdk/Linux_aarch64/24.3/math_libs/nvpl/lib/"));
libnvpl_blas_ilp64_gomp = Libdl.dlpath(Libdl.dlopen("libnvpl_blas_ilp64_gomp"))
libnvpl_blas_lp64_gomp = Libdl.dlpath(Libdl.dlopen("libnvpl_blas_lp64_gomp"))
libnvpl_blas_ilp64_seq = Libdl.dlpath(Libdl.dlopen("libnvpl_blas_ilp64_seq"))
libnvpl_blas_lp64_seq = Libdl.dlpath(Libdl.dlopen("libnvpl_blas_lp64_seq"))
libnvpl_lapack_ilp64_gomp = Libdl.dlpath(Libdl.dlopen("libnvpl_lapack_ilp64_gomp"))
libnvpl_lapack_lp64_gomp = Libdl.dlpath(Libdl.dlopen("libnvpl_lapack_lp64_gomp"))
libnvpl_lapack_ilp64_seq = Libdl.dlpath(Libdl.dlopen("libnvpl_lapack_ilp64_seq"))
libnvpl_lapack_lp64_seq = Libdl.dlpath(Libdl.dlopen("libnvpl_lapack_lp64_seq"))
module NVPL_jll
    function is_available()
        return true
    end
end