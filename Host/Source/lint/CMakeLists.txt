cmake_minimum_required(VERSION 3.15)

# TODO: Scary code. Nothing to do with it now.
# Only generate the PC-lint taget if the option is enabled. Use "make openblt_LINT" to
# lint the project sources
if (LINT_ENABLED)
    # Include PC-lint configuration file for the correct compiler. Currently GNU GCC and
    # Microsoft Visual Studio are supported.
    if (CMAKE_C_COMPILER_ID MATCHES GNU)
        include(${CMAKE_CURRENT_SOURCE_DIR}/gnu/pc_lint.cmake)
    elseif (CMAKE_C_COMPILER_ID MATCHES MSVC)
        include(${CMAKE_CURRENT_SOURCE_DIR}/msvc/pc_lint.cmake)
    endif ()

    # Generate the PC-lint target.
    if (COMMAND add_pc_lint)
        add_pc_lint(openblt ${LIB_SRCS})
    endif ()
endif ()
