cmake_minimum_required(VERSION 3.15)

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

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/CompilerFlags.cmake)

# --------------- #
#   lint macros   #
# --------------- #
add_subdirectory(lint)

# ----------- #
#   OpenBlt   #
# ----------- #
add_subdirectory(LibOpenBLT)

# ----------------- #
#   BootCommander   #
# ----------------- #
add_subdirectory(BootCommander)
