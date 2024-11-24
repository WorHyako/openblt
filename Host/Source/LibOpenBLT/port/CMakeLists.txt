cmake_minimum_required(VERSION 3.15)

project(OpenBlt_Port
        LANGUAGES C)

# ---------------- #
#   OpenBlt port   #
# ---------------- #
add_library(openblt_port)
add_library(openblt::port ALIAS openblt_port)

file(GLOB_RECURSE CommonSources ${CMAKE_CURRENT_SOURCE_DIR}/common/*.c)
if (WIN32)
    file(GLOB_RECURSE Sources ${CMAKE_CURRENT_SOURCE_DIR}/windows/*c)
elseif (UNIX)
    file(GLOB_RECURSE Sources ${CMAKE_CURRENT_SOURCE_DIR}/linux/*c)
endif ()

target_sources(openblt_port
        PRIVATE
        ${CommonSources}
        ${Sources})

target_include_directories(openblt_port
        PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/common
        ${CMAKE_CURRENT_SOURCE_DIR}/interface
        $<$<BOOL:${WIN32}>:${CMAKE_CURRENT_SOURCE_DIR}/windows>
        $<$<BOOL:${WIN32}>:${CMAKE_CURRENT_SOURCE_DIR}/windows/canif/ixxat>
        $<$<BOOL:${WIN32}>:${CMAKE_CURRENT_SOURCE_DIR}/windows/canif/kvaser>
        $<$<BOOL:${WIN32}>:${CMAKE_CURRENT_SOURCE_DIR}/windows/canif/lawicel>
        $<$<BOOL:${WIN32}>:${CMAKE_CURRENT_SOURCE_DIR}/windows/canif/peak>
        $<$<BOOL:${WIN32}>:${CMAKE_CURRENT_SOURCE_DIR}/windows/canif/vector>
        $<$<BOOL:${UNIX}>:${CMAKE_CURRENT_SOURCE_DIR}/linux>
        $<$<BOOL:${UNIX}>:${CMAKE_CURRENT_SOURCE_DIR}/linux/canif/socketcan>)

target_link_libraries(openblt_port
        PUBLIC openblt::osLibs)

target_compile_definitions(openblt_port
        PUBLIC
        $<$<STREQUAL:${CMAKE_C_COMPILER_ID},MSVC>:_CRT_SECURE_NO_WARNINGS>
        $<IF:$<BOOL:${WIN32}>,PLATFORM_WINDOWS,PLATFORM_LINUX>
        $<IF:$<EQUAL:${CMAKE_SIZEOF_VOID_P},4>,PLATFORM_32BIT,PLATFORM_64BIT>)
