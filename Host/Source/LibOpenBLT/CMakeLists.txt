#****************************************************************************************
# \file         CMakeLists.txt
# \brief        CMake descriptor file for the OpenBLT host library.
# \internal
#----------------------------------------------------------------------------------------
#                          C O P Y R I G H T
#----------------------------------------------------------------------------------------
#   Copyright (c) 2017  by Feaser    http://www.feaser.com    All rights reserved
#
#----------------------------------------------------------------------------------------
#                            L I C E N S E
#----------------------------------------------------------------------------------------
# This file is part of OpenBLT. OpenBLT is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# OpenBLT is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
# PURPOSE. See the GNU General Public License for more details.
#
# You have received a copy of the GNU General Public License along with OpenBLT. It 
# should be located in ".\Doc\license.html". If not, contact Feaser to obtain a copy.
# 
# \endinternal
#****************************************************************************************
# Specify the version being used as well as the language
cmake_minimum_required(VERSION 3.15)

# ------------------ #
#   Compiler flags   #
# ------------------ #
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/CompilerFlags.cmake)

project(LibOpenBLT
        LANGUAGES C)

# Build debug version by default
set(CMAKE_BUILD_TYPE "Debug")

#****************************************************************************************
# Options
#****************************************************************************************
# Add option with default value to enable the generation and building of the shared
# library. By default it is turned on. It can be overridden on the command line when 
# CMake is called using the following parameter: -DBUILD_SHARED=OFF
option(BUILD_SHARED "Configurable to enable/disable building of the shared library" ON)

# Add option with default value to enable the generation and building of the static
# library. By default it is turned off. It can be overridden on the command line when 
# CMake is called using the following parameter: -DBUILD_STATIC=ON
option(BUILD_STATIC "Configurable to enable/disable building of the static library" OFF)

# Set the output directory
set(PROJECT_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../../..)

# Set the output directory for the generic no-config case (e.g. with mingw)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_OUTPUT_DIRECTORY})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_OUTPUT_DIRECTORY})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_OUTPUT_DIRECTORY})
# Set the output directory for multi-config builds (e.g. msvc)
foreach (OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
    string(TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${PROJECT_OUTPUT_DIRECTORY})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${PROJECT_OUTPUT_DIRECTORY})
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${PROJECT_OUTPUT_DIRECTORY})
endforeach ()

# ------------- #
#   Port libs   #
# ------------- #
add_subdirectory(port)

#***************************************************************************************
# Search path
#****************************************************************************************
# Add the path of the shared library to the library search path. This way an (optional)
# seed and key shared library file can simply be in the same directory as the LibOpenBLT
# shared library.
set(CMAKE_SKIP_BUILD_RPATH FALSE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
set(CMAKE_INSTALL_RPATH "\$ORIGIN")

# ------------------ #
#   OpenBlt object   #
# ------------------ #
add_library(openblt OBJECT)
add_library(openblt::obj ALIAS openblt)

target_include_directories(openblt
        PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

file(GLOB Sources ${CMAKE_CURRENT_SOURCE_DIR}/*.c)
target_sources(openblt
        PRIVATE ${Sources})

target_link_libraries(openblt
        PUBLIC
        PkgConfig::libusb
        openblt::port)

# ---------------- #
#   Lint targets   #
# ---------------- #
add_subdirectory(lint)

# ------------------ #
#   OpenBlt static   #
# ------------------ #
add_library(openblt_static STATIC)
add_library(openblt::static ALIAS openblt_static)

target_link_libraries(openblt_static
        PUBLIC openblt)

set_target_properties(openblt_static PROPERTIES
        OUTPUT_NAME openblt
        CLEAN_DIRECT_OUTPUT 1)

# ------------------ #
#   OpenBlt shared   #
# ------------------ #
add_library(openblt_shared SHARED)
add_library(openblt::shared ALIAS openblt_shared)

target_link_libraries(openblt_shared
        PUBLIC openblt)

# Microsoft Visual Studio does not add "lib" to the name of the DLL, whereas GCC
# (including MinGW) does. Correct this here.
set_target_properties(openblt_shared PROPERTIES
        OUTPUT_NAME $<$<STREQUAL:${CMAKE_C_COMPILER_ID},MSVC>:lib>openblt
        CLEAN_DIRECT_OUTPUT 1)
