cmake_minimum_required(VERSION 3.16)

project(fortran-sperr LANGUAGES Fortran)

# Set default build type to Release if not specified
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the type of build (Debug or Release)" FORCE)
endif()

# Set compiler flags for Debug build
set(CMAKE_Fortran_FLAGS_DEBUG "-g -fcheck=bounds -Wall -Wextra -fmax-errors=1 -fbacktrace")

# Set compiler flags for Release build
set(CMAKE_Fortran_FLAGS_RELEASE "-O3")

# Set compiler flags based on build type
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${CMAKE_Fortran_FLAGS_${CMAKE_BUILD_TYPE}}")

find_package(PkgConfig REQUIRED)
pkg_search_module(LIBRARY_NAME REQUIRED SPERR)

include_directories(${LIBRARY_NAME_INCLUDE_DIRS})
link_directories(${LIBRARY_NAME_LIBRARY_DIRS})

# List of source files
set(SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)
set(TEST_DIR ${CMAKE_CURRENT_SOURCE_DIR}/test)

set(SRC_FILES
  ${SRC_DIR}/sperr.f90
)

set(TEST_2D_FILES
  ${TEST_DIR}/test_sperr_2d.f90
)

set(TEST_3D_FILES
  ${TEST_DIR}/test_sperr_3d.f90
)

# Create executables in the root directory and link with the object library
add_executable(2d ${TEST_2D_FILES} ${SRC_FILES})
add_executable(3d ${TEST_3D_FILES} ${SRC_FILES})

foreach(TARGET_NAME 2d 3d)
  target_link_libraries(${TARGET_NAME} SPERR)
  set_target_properties(${TARGET_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
endforeach()
