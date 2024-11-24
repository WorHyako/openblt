cmake_minimum_required(VERSION 3.15)

project(OpenBlt)

# ----------- #
#   Options   #
# ----------- #
# Add option with default value to disable the generation of the PC-lint target. It can
# be overridden on the command line when CMake is called using the following parameter:
# -DLINT_ENABLED=ON
option(LINT_ENABLED "Configurable to enable/disable the PC-lint target" OFF)

# Add option with default value to enable the generation and building of the shared
# library. By default it is turned on. It can be overridden on the command line when
# CMake is called using the following parameter: -DBUILD_SHARED_LIBS=OFF
option(BUILD_SHARED_LIBS "Configurable to enable/disable building of the shared library" ON)

# -------------------- #
#   Output directory   #
# -------------------- #
set(PROJECT_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../..)

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

# ---------------- #
#   Search paths   #
# ---------------- #
# Add the path of the shared library to the library search path. This way an (optional)
# seed and key shared library file can simply be in the same directory as the LibOpenBLT
# shared library.
set(CMAKE_SKIP_BUILD_RPATH FALSE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
set(CMAKE_INSTALL_RPATH "\$ORIGIN")

# ------------------ #
#   Compiler flags   #
# ------------------ #
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/CompilerFlags.cmake)

# ----------- #
#   OpenBlt   #
# ----------- #
add_subdirectory(LibOpenBLT)

# ----------------- #
#   BootCommander   #
# ----------------- #
add_subdirectory(BootCommander)

# ------------ #
#   SeedNKey   #
# ------------ #
add_subdirectory(SeedNKey)

# --------------- #
#   lint macros   #
# --------------- #
if (LINT_ENABLED)
    list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/lint)

    add_subdirectory(lint)
endif ()
