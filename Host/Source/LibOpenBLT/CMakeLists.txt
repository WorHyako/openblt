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

project(LibOpenBLT
        LANGUAGES C)

# ------------- #
#   Port libs   #
# ------------- #
add_subdirectory(port)

# ----------- #
#   OpenBlt   #
# ----------- #
add_library(openblt)
add_library(openblt::openblt ALIAS openblt)

target_include_directories(openblt
        PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

file(GLOB Sources ${CMAKE_CURRENT_SOURCE_DIR}/*.c)

target_sources(openblt
        PRIVATE ${Sources})

target_link_libraries(openblt
        PUBLIC
        openblt::port
        openblt::osLibs)
