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

# External dependencies
set(extern_INCLUDE /Users/oscarmojica/lossy_compression/include)
set(extern_LIB /Users/oscarmojica/lossy_compression/lib)
include_directories(${extern_INCLUDE})
link_directories(${extern_LIB})

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

# Create an object library for common source files in the src folder
add_library(sperr_object OBJECT ${SRC_FILES})

# Create executables in the root directory and link with the object library
add_executable(2d ${TEST_2D_FILES} $<TARGET_OBJECTS:sperr_object>)
add_executable(3d ${TEST_3D_FILES} $<TARGET_OBJECTS:sperr_object>)

foreach(TARGET_NAME 2d 3d)
  target_link_libraries(${TARGET_NAME} SPERR)
  set_target_properties(${TARGET_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
endforeach()


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

# External dependencies (provide default values, users can override)
set(EXTERN_INCLUDE_DIR /path/to/lossy_compression/include CACHE PATH "Path to lossy_compression include directory")
set(EXTERN_LIB_DIR /path/to/lossy_compression/lib CACHE PATH "Path to lossy_compression lib directory")

include_directories(${EXTERN_INCLUDE_DIR})
link_directories(${EXTERN_LIB_DIR})

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

# Create an object library for common source files in the src folder
add_library(sperr_object OBJECT ${SRC_FILES})

# Check if the test folder exists, and create it if not
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/test)

# Create executables in the root directory and link with the object library
add_executable(2d ${TEST_2D_FILES} $<TARGET_OBJECTS:sperr_object>)
add_executable(3d ${TEST_3D_FILES} $<TARGET_OBJECTS:sperr_object>)

foreach(TARGET_NAME 2d 3d)
  target_link_libraries(${TARGET_NAME} SPERR)
  set_target_properties(${TARGET_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
endforeach()
