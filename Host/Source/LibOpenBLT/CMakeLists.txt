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
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/ThirdParty.cmake)

project(LibOpenBLT
        LANGUAGES C)

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

# ----------- #
#   OpenBlt   #
# ----------- #
add_library(openblt)
add_library(openblt::openblt ALIAS openblt)

set_target_properties(openblt
        PROPERTIES
        POSITION_INDEPENDENT_CODE ${BUILD_SHARED_LIBS}
        CLEAN_DIRECT_OUTPUT 1
        # Microsoft Visual Studio does not add "lib" to the name of the DLL, whereas GCC
        # (including MinGW) does. Correct this here.
        OUTPUT_NAME $<$<BOOL:${BUILD_SHARED_LIBS}>:lib>openblt)

target_include_directories(openblt
        PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
        $<$<BOOL:WIN32>:${CMAKE_CURRENT_SOURCE_DIR}/port/windows>
        $<$<BOOL:WIN32>:${CMAKE_CURRENT_SOURCE_DIR}/port/windows/canif/ixxat>
        $<$<BOOL:WIN32>:${CMAKE_CURRENT_SOURCE_DIR}/port/windows/canif/kvaser>
        $<$<BOOL:WIN32>:${CMAKE_CURRENT_SOURCE_DIR}/port/windows/canif/lawicel>
        $<$<BOOL:WIN32>:${CMAKE_CURRENT_SOURCE_DIR}/port/windows/canif/peak>
        $<$<BOOL:WIN32>:${CMAKE_CURRENT_SOURCE_DIR}/port/windows/canif/vector>
        $<$<BOOL:UNIX>:${CMAKE_CURRENT_SOURCE_DIR}/port/linux>
        $<$<BOOL:UNIX>:${CMAKE_CURRENT_SOURCE_DIR}/port/linux/canif/socketcan>)

file(GLOB Sources ${CMAKE_CURRENT_SOURCE_DIR}/*.c)
if (WIN32)
    file(GLOB_RECURSE PortSources port/windows/*.c)
elseif (UNIX)
    file(GLOB_RECURSE PortSources port/linux/*.c)
endif ()

target_sources(openblt
        PRIVATE
        ${Sources}
        ${PortSources})

target_link_libraries(openblt
        PUBLIC
        PkgConfig::libusb
        openblt::port
        openblt::osLibs)
