cmake_minimum_required(VERSION 3.15)

# This file contains functions and configurations for generating PC-Lint build
# targets for your CMake projects.

set(PC_LINT_EXECUTABLE "C:/Lint/lint-nt.exe" CACHE STRING "full path to the pc-lint executable. NOT the generated lin.bat")
set(PC_LINT_CONFIG_DIR "${CMAKE_SOURCE_DIR}/lint/$<IF:$<STREQUAL:${CMAKE_C_COMPILER_ID},MSVC>,msvc,gnu" CACHE STRING "full path to the directory containing pc-lint configuration files")
set(PC_LINT_USER_FLAGS "-b" CACHE STRING "additional pc-lint command line options -- some flags of pc-lint cannot be set in option files (most notably -b)")

# a phony target which causes all available *_LINT targets to be executed
add_custom_target(ALL_LINT)

include(CMakeParseArguments)

# add_pc_lint(target source1 [source2 ...])
#
# Takes a list of source files and generates a build target which can be used
# for linting all files
#
# The generated lint commands assume that a top-level config file named
# 'std.lnt' resides in the configuration directory 'PC_LINT_CONFIG_DIR'. This
# config file must include all other config files. This is standard lint
# behaviour.
#
# Parameters:
#  - target: the name of the target to which the sources belong. You will get a
#            new build target named ${target}_LINT
#  - source1 ... : a list of source files to be linted. Just pass the same list
#            as you passed for add_executable or add_library. Everything except
#            C and CPP files (*.c, *.cpp, *.cxx) will be filtered out.
#
# Example:
#  If you have a CMakeLists.txt which generates an executable like this:
#
#    set(MAIN_SOURCES main.c foo.c bar.c)
#    add_executable(main ${MAIN_SOURCES})
#
#  include this file
#
#    include(/path/to/pc_lint.cmake)
#
#  and add a line to generate the main_LINT target
#
#   if(COMMAND add_pc_lint)
#    add_pc_lint(main ${MAIN_SOURCES})
#   endif(COMMAND add_pc_lint)
#
function(add_pc_lint)
    set(multiValueArgs TARGETS)
    set(oneValueArgs NAME)

    cmake_parse_arguments(ARG
            "${options}"
            "${oneValueArgs}"
            "${multiValueArgs}"
            ${ARGN})

    foreach (Target ${ARG_TARGETS})
        get_target_property(Target_Includes
                ${Target} INCLUDE_DIRECTORIES)
        get_target_property(Target_Defines
                ${Target} COMPILE_DEFINITIONS)
        get_target_property(Target_Sources
                ${Target} SOURCES)

        foreach (Source_File ${Target_Sources})
            list(APPEND Pc_Lint_Commands
                    COMMAND ${PC_LINT_EXECUTABLE}
                    -i"${PC_LINT_CONFIG_DIR}" std.lnt
                    "-u" ${PC_LINT_USER_FLAGS}
                    # prepend each include directory with "-i"; also quotes the directory
                    $<LIST:TRANSFORM,${Target_Includes},PREPEND,-i>
                    # prepend each definition with "-d"
                    $<IF:$<STREQUAL:${Target_Defines},Target_Defines-NOTFOUND>,,$<LIST:TRANSFORM,${Target_Defines},PREPEND,-d>>
                    ${Source_File})
        endforeach ()
    endforeach ()

    # add a custom target consisting of all the commands generated above
    add_custom_target(${ARG_NAME}_LINT ${Pc_Lint_Commands} VERBATIM)
    # make the ALL_LINT target depend on each and every *_LINT target
    add_dependencies(ALL_LINT ${ARG_NAME}_LINT)

endfunction()
