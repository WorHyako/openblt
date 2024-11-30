#****************************************************************************************
# \file         CMakeLists.txt
# \brief        CMake descriptor file for the XCP Seed and Key shared library.
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

project(SeedNKey
        LANGUAGES C)

# ------------ #
#   SeedNKey   #
# ------------ #
# Set main target. Use "make seednkey" to individually build the library.
add_library(seednkey)
add_library(openblt::seednkey ALIAS seednkey)

target_sources(seednkey
        PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/seednkey.c)

target_include_directories(seednkey
        PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

set_target_properties(seednkey
        PROPERTIES
        POSITION_INDEPENDENT_CODE ${BUILD_SHARED_LIBS})
