using Libdl
const libnvpl_blas_ilp64_gomp = Libdl.dlpath(Libdl.find_library("libnvpl_blas_ilp64_gomp"))
const libnvpl_blas_lp64_gomp = Libdl.dlpath(Libdl.find_library("libnvpl_blas_lp64_gomp"))
const libnvpl_blas_ilp64_seq = Libdl.dlpath(Libdl.find_library("libnvpl_blas_ilp64_seq"))
const libnvpl_blas_lp64_seq = Libdl.dlpath(Libdl.find_library("libnvpl_blas_lp64_seq"))
const libnvpl_lapack_ilp64_gomp = Libdl.dlpath(Libdl.find_library("libnvpl_lapack_ilp64_gomp"))
const libnvpl_lapack_lp64_gomp = Libdl.dlpath(Libdl.find_library("libnvpl_lapack_lp64_gomp"))
const libnvpl_lapack_ilp64_seq = Libdl.dlpath(Libdl.find_library("libnvpl_lapack_ilp64_seq"))
const libnvpl_lapack_lp64_seq = Libdl.dlpath(Libdl.find_library("libnvpl_lapack_lp64_seq"))
module NVPL_jll
    function is_available()
        return true
    end
end