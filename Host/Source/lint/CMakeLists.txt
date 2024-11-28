cmake_minimum_required(VERSION 3.15)

project(Lint
        LANGUAGES NONE)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR})
include(pc_lint)

# ---------------- #
#   openblt_LINT   #
# ---------------- #
add_pc_lint(TARGET openblt NAME openblt)

# ----------------------- #
#    BootCommander_LINT   #
# ----------------------- #
add_pc_lint(TARGET BootCommander NAME BootCommander)

# ----------------- #
#   seednkey_LINT   #
# ----------------- #
add_pc_lint(TARGET seednkey NAME seednkey)
