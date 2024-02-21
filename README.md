# fortran-sperr

[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![Fortran](https://img.shields.io/badge/Fortran-734f96?logo=fortran&style=flat)](https://fortran-lang.org)
[![fpm](https://img.shields.io/badge/fpm-Fortran_package_manager-734f96)](https://fpm.fortran-lang.org)


Fortran bindings to [SPERR](https://github.com/NCAR/SPERR) - a library for lossy compression of scientific data. :clamp:


## Build Instructions

To build the examples in this project you need:

* A Fortran compiler supporting Fortran 2008 or later (gfortran or ifort)
* One of the supported build systems
    * CMake version 3.16 or later
    * Fortran package manager (fpm) version 0.2.0 or newer
* [SPERR](https://github.com/NCAR/SPERR). Please see the installation instructions at https://github.com/NCAR/SPERR/wiki/Build-SPERR-From-Source

### CMake

In [CMakeLists.txt](https://github.com/ofmla/fortran-sperr/blob/main/CMakeLists.txt) I added two CMake variables (EXTERN_INCLUDE_DIR and EXTERN_LIB_DIR) to specify the paths to the include and lib directories of the SPERR library. Users can provide their paths by setting these variables when running CMake.

Configure the build with
```
cmake -S . -DEXTERN_INCLUDE_DIR=/path/to/SPERR/include -DEXTERN_LIB_DIR=/path/to/SPERR/lib
```
To build the executables run
```
make
```
The executables will be named `2d` and `3d`, and they will be placed in the root directory.

### fpm

Alternatively, you can build the executables via fpm with (assuming SPERR is already installed):

```
fpm build --link-flag "-L/path/to/SPERR/lib"
```
or by setting the `FPM_LDFLAGS=-L/path/to/SPERR/lib` environment variable and then `fpm build`. The executables will be named `test_2d` and `test_3d`. They will be located in a folder named `app`, which resides within another folder (compiler+hash) in the `build` directory.

### Notes :page_facing_up:

* Input files, such as `lena512.float` and `density_128x128x256.d64` required by the examples, are not included. Obtain them [here](https://github.com/NCAR/SPERR/tree/main/test_data) and place them in the corresponding folder depending on the build system used.
*  **(de)compression functions are working properly but proper functions for bit stream I/O are still required for real applications**
*  The folder compiler+hash mentioned in the fpm section can be named differently depending on the compiler used. For example, it might be ifort+hash or gfortran+hash depending on whether Intel Fortran or GNU Fortran is used.

## License

fortran-sperr is distributed under the BSD license. See the included [LICENSE](https://github.com/ofmla/fortran-sperr/blob/main/LICENSE) file for details.
