cmake_minimum_required(VERSION 3.15)

# ------------------------ #
#   Collect OS libraries   #
# ------------------------ #
find_library(SetupApi REQUIRED
        NAMES setupapi)
find_library(Ws2_32 REQUIRED
        NAMES ws2_32)
find_library(WinUsb REQUIRED
        NAMES winusb)

add_library(OsLibs INTERFACE)
add_library(openblt::osLibs ALIAS OsLibs)

target_link_libraries(OsLibs
        INTERFACE
        ${SetupApi}
        ${Ws2_32}
        ${WinUsb})

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
        ${CMAKE_CURRENT_SOURCE_DIR}/canif/ixxat
        ${CMAKE_CURRENT_SOURCE_DIR}/canif/kvaser
        ${CMAKE_CURRENT_SOURCE_DIR}/canif/lawicel
        ${CMAKE_CURRENT_SOURCE_DIR}/canif/peak
        ${CMAKE_CURRENT_SOURCE_DIR}/canif/vector)

target_link_libraries(openblt_port
        PUBLIC openblt::osLibs)

target_compile_definitions(openblt_port
        PUBLIC
        PLATFORM_WINDOWS
        $<IF:$<EQUAL:${CMAKE_SIZEOF_VOID_P},4>,PLATFORM_32BIT,PLATFORM_64BIT>)
