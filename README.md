# fortran-sperr

[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![Fortran](https://img.shields.io/badge/Fortran-734f96?logo=fortran&style=flat)](https://fortran-lang.org)
[![fpm](https://img.shields.io/badge/fpm-Fortran_package_manager-734f96)](https://fpm.fortran-lang.org)
![Build Status](https://github.com/ofmla/fortran-sperr/actions/workflows/test_bindings.yml/badge.svg)


Fortran bindings to [SPERR](https://github.com/NCAR/SPERR) - a library for lossy compression of scientific data. :clamp:


## Build Instructions

To build the examples in this project you need:

* A Fortran compiler supporting Fortran 2008 or later (gfortran or ifort)
* One of the supported build systems
    * CMake version 3.16 or later
    * Fortran package manager (fpm) version 0.2.0 or newer
* [SPERR](https://github.com/NCAR/SPERR). Please see the installation instructions at https://github.com/NCAR/SPERR/wiki/Build-SPERR-From-Source

### CMake

In [CMakeLists.txt](https://github.com/ofmla/fortran-sperr/blob/main/CMakeLists.txt), the project uses `find_package(PkgConfig REQUIRED)` and `pkg_search_module(LIBRARY_NAME REQUIRED SPERR)` to locate the `SPERR` library. This means that users no longer need to manually specify the paths to the include and lib directories.

To configure the build, simply run:
```
cmake -S .
```
To build the executables using `make`, run:
```
make
```
The executables will be named `2d` and `3d`, and they will be placed in the root directory.

Please note that when installing the SPERR library with CMake, you may need to use `sudo` as regular users typically don't have write permissions for directories like `/usr` and `/usr/local` in modern Linux systems.

### fpm

Alternatively, you can build the executables via fpm with (assuming SPERR is already installed):

```
fpm build --link-flag "-L/path/to/SPERR/lib"
```
or by setting the `FPM_LDFLAGS=-L/path/to/SPERR/lib` environment variable and then `fpm build`. The executables will be named `test_2d` and `test_3d`. They will be located in a folder named `app`, which resides within another folder named after the compiler and hash in the `build` directory.

When using fpm to build executables, the build artifacts are placed in a directory named after the compiler and hash (e.g., `gfortran_50F62D7499E64B65`). Here, the hash (`50F62D7499E64B65` in this example) represents a unique identifier for the specific build configuration. If you need more accurate information about how fpm organizes build artifacts and the significance of the hash, it's best to consult the fpm documentation or reach out to the developers of the tool for clarification.

### Notes :page_facing_up:

* Input files, such as `lena512.float` and `density_128x128x256.d64` required by the examples, are not included. Obtain them [here](https://github.com/NCAR/SPERR/tree/main/test_data) and place them in the corresponding folder depending on the build system used.
*  **(de)compression functions are working properly but proper functions for bit stream I/O are still required for real applications**
*  The folder compiler+hash mentioned in the fpm section can be named differently depending on the compiler used. For example, it might be ifort+hash or gfortran+hash depending on whether Intel Fortran or GNU Fortran is used.

## License

fortran-sperr is distributed under the BSD license. See the included [LICENSE](https://github.com/ofmla/fortran-sperr/blob/main/LICENSE) file for details.
