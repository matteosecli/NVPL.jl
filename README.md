# NVPL.jl

## Using Julia with NVIDIA's NVPL

NVPL.jl is a Julia package that allows users to use the NVIDIA Performance Libraries (NVPL) library for Julia's underlying BLAS and LAPACK, instead of OpenBLAS, which Julia ships with by default. Julia includes [libblastrampoline](https://github.com/staticfloat/libblastrampoline), which enables picking a BLAS and LAPACK library at runtime. A [JuliaCon 2021 talk](https://www.youtube.com/watch?v=t6hptekOR7s) provides details on this mechanism. 

This package requires Julia 1.9+, and only covers the forwarding of BLAS and LAPACK routines in Julia to NVPL. It is inspired by [MKL.jl](https://github.com/JuliaLinearAlgebra/MKL.jl).

## Usage

Just do
```julia
using NVPL
```
after installation and you're good to go. It's probably a good idea to load it before other packages, but not strictly necessary as it is for e.g. MKL.jl, as NVPL doesn't include its own OpenMP runtime and defaults to the GNU OpenMP one.

## Requirements

NVPL is only available on Linux 64-bit systems, and only for CPUs with [Armv8.1-A or later architecture](https://docs.nvidia.com/nvpl/latest/#cpu-support). ILP64 is used by default; OpenBLAS is used as a fallback for `{s,d}gemmt` until they are implemented (NVIDIA Bug ID: [#5292829](https://partners.nvidia.com/bug/viewbug/5292829)).

## Installation

Adding the package will replace the system BLAS and LAPACK with NVPL provided ones at runtime. Note that the NVPL package has to be loaded in every new Julia process. Upon quitting and restarting, Julia will start with the default OpenBLAS.
```julia
julia> using Pkg; Pkg.add("NVPL")
```

## Check installation

```julia
julia> using LinearAlgebra

julia> BLAS.get_config()
LinearAlgebra.BLAS.LBTConfig
Libraries: 
└ [ILP64] libopenblas64_.so

julia> using NVPL

julia> BLAS.get_config()
LinearAlgebra.BLAS.LBTConfig
Libraries:
├ [ILP64] libopenblas64_.so
├ [ILP64] libnvpl_blas_ilp64_gomp.so
```

## Threading layer

You can explicitly choose whether to use multi-threaded (default) or sequential BLAS/LAPACK routines.

To switch to the sequential routines, use:
```julia
using NVPL

NVPL.lbt_forward_to_nvpl(layer = NVPL.THREADING_SEQUENTIAL)
```
The default is `layer = NVPL.THREADING_GNU`.

## LAPACK forwarding

LAPACK forwarding is currently disabled by default, due to the [admittedly limited optimizations](https://docs.nvidia.com/nvpl/latest/lapack/api/overview.html). You can enabled it via

```julia
using NVPL

NVPL.lbt_forward_to_nvpl(lapack = true)
```

## Service APIs

NVPL.jl wraps NVPL BLAS/LAPACK service APIs. You can call them via
```julia
using NVPL

NVPL.[blas,lapack]_get_version()
NVPL.[blas,lapack]_get_max_threads()
NVPL.[blas,lapack]_set_num_threads(nth::Int)
NVPL.[blas,lapack]_set_num_threads_local(nth_local::Int)
```
Refer to NVPL's [BLAS](https://docs.nvidia.com/nvpl/latest/blas/api/service.html) and [LAPACK](https://docs.nvidia.com/nvpl/latest/lapack/api/service.html) documentation for further information.