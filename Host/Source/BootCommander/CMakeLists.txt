#****************************************************************************************
# \file         CMakeLists.txt
# \brief        CMake descriptor file for BootCommander command line program.
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

#****************************************************************************************
# Project configuration
#****************************************************************************************
# Specify the project name
project(BootCommander
        LANGUAGES C)

#****************************************************************************************
# Directories
#****************************************************************************************
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
endforeach (OUTPUTCONFIG CMAKE_CONFIGURATION_TYPES)

#***************************************************************************************
# Search path
#****************************************************************************************
# Add the path of the executable to the library search path. This way the LibOpenBLT
# shared library can simply be in the same directory as the BootCommander executable.
set(CMAKE_SKIP_BUILD_RPATH FALSE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
set(CMAKE_INSTALL_RPATH "\$ORIGIN")

# ----------------- #
#   BootCommander   #
# ----------------- #
# Set main target. Use "make BootCommander" to individually build the program.
add_executable(BootCommander)

target_sources(BootCommander
        PRIVATE main.c)

target_link_libraries(BootCommander
        PRIVATE openblt::openblt)
