cmake_minimum_required(VERSION 3.15)

if (CMAKE_C_COMPILER_ID MATCHES GNU)
    set(CompilerFlag "-std=gnu99")
elseif (CMAKE_C_COMPILER_ID MATCHES MSVC)
    # Configure a statically linked run-time library for msvc
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
    set(CompilerFlag "")
endif ()

if(WIN32)
elseif (UNIX)
    set(PlatformFlag "-pthread")
endif ()

list(APPEND CMAKE_C_FLAGS ${PlatformFlag} ${PointerSizeFlag} ${CompilerFlag})
