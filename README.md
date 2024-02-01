# fortran-sperr

[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

Fortran bindings to [SPERR](https://github.com/NCAR/SPERR) - a library for lossy compression of scientific data.


## Build Instructions

To build the examples in this project you need:

* A Fortran compiler supporting Fortran 2008 or later (gfortran or ifort)
* CMake version 3.16 or later
* [SPERR](https://github.com/NCAR/SPERR). Please see the installation instructions at https://github.com/NCAR/SPERR/wiki/Build-SPERR-From-Source

In [CMakeLists.txt](https://github.com/ofmla/fortran-sperr/blob/main/CMakeLists.txt) I added two CMake variables (EXTERN_INCLUDE_DIR and EXTERN_LIB_DIR) to specify the paths to the include and lib directories of the SPERR library. Users can provide their paths by
setting these variables when running CMake.

Configure the build with

```
cmake -S . -DEXTERN_INCLUDE_DIR=/path/to/SPERR/include -DEXTERN_LIB_DIR=/path/to/SPERR/lib
```

To build the executables run

```
make
```

You should get input files `lena512.float` and `density_128x128x256.d64` from https://github.com/NCAR/SPERR/tree/main/test_data and place them in the root directory and then simply run the examples with

```
./2d
```

or

```
./3d
```

## License

fortran-sperr is distributed under the BSD license. See the included [LICENSE](https://github.com/ofmla/fortran-sperr/blob/main/LICENSE) file for details.
