function blas_get_version()::VersionNumber
    if _libnvpl_blas_path[] == libnvpl_blas_ilp64_gomp
        return _nvpl_int_to_version(ccall((:nvpl_blas_get_version, libnvpl_blas_ilp64_gomp), Cint, ()))
    elseif _libnvpl_blas_path[] == libnvpl_blas_ilp64_seq
        return _nvpl_int_to_version(ccall((:nvpl_blas_get_version, libnvpl_blas_ilp64_seq), Cint, ()))
    elseif _libnvpl_blas_path[] == libnvpl_blas_lp64_gomp
        return _nvpl_int_to_version(ccall((:nvpl_blas_get_version, libnvpl_blas_lp64_gomp), Cint, ()))
    elseif _libnvpl_blas_path[] == libnvpl_blas_lp64_seq
        return _nvpl_int_to_version(ccall((:nvpl_blas_get_version, libnvpl_blas_lp64_seq), Cint, ()))
    else
        error("Unknown library path: $libnvpl_blas_path[]")
    end
end

function blas_get_max_threads()::Int
    if _libnvpl_blas_path[] == libnvpl_blas_ilp64_gomp
        return Int(ccall((:nvpl_blas_get_max_threads, libnvpl_blas_ilp64_gomp), Cint, ()))
    elseif _libnvpl_blas_path[] == libnvpl_blas_ilp64_seq
        return Int(ccall((:nvpl_blas_get_max_threads, libnvpl_blas_ilp64_seq), Cint, ()))
    elseif _libnvpl_blas_path[] == libnvpl_blas_lp64_gomp
        return Int(ccall((:nvpl_blas_get_max_threads, libnvpl_blas_lp64_gomp), Cint, ()))
    elseif _libnvpl_blas_path[] == libnvpl_blas_lp64_seq
        return Int(ccall((:nvpl_blas_get_max_threads, libnvpl_blas_lp64_seq), Cint, ()))
    else
        error("Unknown library path: $libnvpl_blas_path[]")
    end
end

function blas_set_num_threads(nthr::Int)
    if _libnvpl_blas_path[] == libnvpl_blas_ilp64_gomp
        ccall((:nvpl_blas_set_num_threads, libnvpl_blas_ilp64_gomp), Cvoid, (Ref{Cint},), Cint(nthr))
    elseif _libnvpl_blas_path[] == libnvpl_blas_ilp64_seq
        ccall((:nvpl_blas_set_num_threads, libnvpl_blas_ilp64_seq), Cvoid, (Ref{Cint},), Cint(nthr))
    elseif _libnvpl_blas_path[] == libnvpl_blas_lp64_gomp
        ccall((:nvpl_blas_set_num_threads, libnvpl_blas_lp64_gomp), Cvoid, (Ref{Cint},), Cint(nthr))
    elseif _libnvpl_blas_path[] == libnvpl_blas_lp64_seq
        ccall((:nvpl_blas_set_num_threads, libnvpl_blas_lp64_seq), Cvoid, (Ref{Cint},), Cint(nthr))
    else
        error("Unknown library path: $libnvpl_blas_path[]")
    end
end

function blas_set_num_threads_local(nthr_local::Int)
    if _libnvpl_blas_path[] == libnvpl_blas_ilp64_gomp
        ccall((:nvpl_blas_set_num_threads_local, libnvpl_blas_ilp64_gomp), Cvoid, (Ref{Cint},), Cint(nthr_local))
    elseif _libnvpl_blas_path[] == libnvpl_blas_ilp64_seq
        ccall((:nvpl_blas_set_num_threads_local, libnvpl_blas_ilp64_seq), Cvoid, (Ref{Cint},), Cint(nthr_local))
    elseif _libnvpl_blas_path[] == libnvpl_blas_lp64_gomp
        ccall((:nvpl_blas_set_num_threads_local, libnvpl_blas_lp64_gomp), Cvoid, (Ref{Cint},), Cint(nthr_local))
    elseif _libnvpl_blas_path[] == libnvpl_blas_lp64_seq
        ccall((:nvpl_blas_set_num_threads_local, libnvpl_blas_lp64_seq), Cvoid, (Ref{Cint},), Cint(nthr_local))
    else
        error("Unknown library path: $libnvpl_blas_path[]")
    end
end