cmake_minimum_required(VERSION 3.15)

# This file contains functions and configurations for generating PC-Lint build
# targets for your CMake projects.

set(PC_LINT_EXECUTABLE "lint-nt.exe" CACHE STRING "full path to the pc-lint executable. NOT the generated lin.bat")
set(PC_LINT_CONFIG_DIR "${CMAKE_CURRENT_SOURCE_DIR}/msvc" CACHE STRING "full path to the directory containing pc-lint configuration files")
set(PC_LINT_USER_FLAGS "-b" CACHE STRING "additional pc-lint command line options -- some flags of pc-lint cannot be set in option files (most notably -b)")

# A phony target which causes all available *_LINT targets to be executed
add_custom_target(ALL_LINT)

include(CMakeParseArguments)

# add_pc_lint(TARGET target NAME name)
#
# Takes a non-alias target and name for new lint target and generates a build target which can be used
# for linting all files
#
# Parameters:
#  - target :
#  - name   :
#
# Example:
#  If you have a CMakeLists.txt which generates an executable like this:
#
#   add_executable(main ${MAIN_SOURCES})
#
#   set(Sources main.c foo.c bar.c)
#   target_sources(main
#           PRIVATE ${Sources})
#
#
#   include this file
#   list(APPEND CMAKE_MODULE_PATH /path/to/pc_lint.cmake)
#   include(pc_lint)
#
#   and add a line to generate the main_LINT target
#
#   add_pc_lint(TARGET main NAME Main_Lint)
function(add_pc_lint)
    set(oneValueArgs TARGET NAME)

    cmake_parse_arguments(ARG
            "${options}"
            "${oneValueArgs}"
            "${multiValueArgs}"
            ${ARGN})

    get_target_property(Target_Sources
            ${ARG_TARGET} SOURCES)

    # Original include files
    set(Include_Files $<TARGET_PROPERTY:${ARG_TARGET},INCLUDE_DIRECTORIES>)
    # Append/prepend '\"' for each file
    set(Include_Files $<LIST:TRANSFORM,${Include_Files},APPEND,\">)
    set(Include_Files $<LIST:TRANSFORM,${Include_Files},PREPEND,\">)
    # Prepend '-i' to each file
    set(Include_Files $<LIST:TRANSFORM,${Include_Files},PREPEND,-i>)
    # Remove empty '-i""' from list
    set(Include_Files $<LIST:REMOVE_ITEM,${Include_Files},-i\"\">)

    # Original definitions
    set(Definitions $<TARGET_PROPERTY:${ARG_TARGET},COMPILE_DEFINITIONS>)
    # Append/prepend '\"' for each definition
    set(Definitions $<LIST:TRANSFORM,${Definitions},APPEND,\">)
    set(Definitions $<LIST:TRANSFORM,${Definitions},PREPEND,\">)
    # Prepend -d for each definition
    set(Definitions $<LIST:TRANSFORM,${Definitions},PREPEND,-d>)
    # Remove empty '-d' from list
    set(Definitions $<LIST:REMOVE_ITEM,${Definitions},-d\"\">)

    foreach (Source_File ${Target_Sources})
        list(APPEND Pc_Lint_Commands
                COMMAND ${PC_LINT_EXECUTABLE}
                -i"${PC_LINT_CONFIG_DIR}" std.lnt
                "-u" ${PC_LINT_USER_FLAGS}
                ${Include_Files}
                ${Definitions}
                ${Source_File})
    endforeach ()

    # add a custom target consisting of all the commands generated above
    add_custom_target(${ARG_NAME}_LINT ${Pc_Lint_Commands} COMMAND_EXPAND_LISTS VERBATIM)
    # make the ALL_LINT target depend on each and every *_LINT target
    add_dependencies(ALL_LINT ${ARG_NAME}_LINT)
endfunction()
