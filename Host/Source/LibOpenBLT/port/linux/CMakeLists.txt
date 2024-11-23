cmake_minimum_required(VERSION 3.15)

# ------------------------ #
#   Collect OS libraries   #
# ------------------------ #
find_library(Dl REQUIRED
        NAMES dl)
add_library(OsLibs INTERFACE)

target_link_libraries(OsLibs
        INTERFACE ${Dl})

# ---------------- #
#   OpenBlt port   #
# ---------------- #
add_library(openblt_port)
add_library(openblt::port ALIAS openblt_port)

file(GLOB_RECURSE Sources ${CMAKE_CURRENT_SOURCE_DIR}/*.c)
target_sources(openblt_port
        PRIVATE ${Sources})

target_include_directories(openblt_port
        PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/canif/socketcan)

target_link_libraries(openblt_port
        PUBLIC OsLibs)

target_compile_definitions(openblt_port
        PUBLIC
        PLATFORM_LINUX
        $<IF:$<EQUAL:${CMAKE_SIZEOF_VOID_P},4>,PLATFORM_32BIT,PLATFORM_64BIT>)
