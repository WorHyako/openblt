cmake_minimum_required(VERSION 3.15)

# Set platform specific compiler macros PLATFORM_XXX
if (CMAKE_SIZEOF_VOID_P EQUAL 4)
    set(PointerSizeFlag "-DPLATFORM_32BIT")
else ()
    set(PointerSizeFlag "-DPLATFORM_64BIT")
endif ()

if (CMAKE_C_COMPILER_ID MATCHES GNU)
    set(CompilerFlag "-std=gnu99")
elseif (CMAKE_C_COMPILER_ID MATCHES MSVC)
    # Configure a statically linked run-time library for msvc
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
    set(CompilerFlag "")
endif ()

if(WIN32)
    set(PlatformFlag "-DPLATFORM_WINDOWS -D_CRT_SECURE_NO_WARNINGS")
elseif (UNIX)
    set(PlatformFlag "-DPLATFORM_LINUX -pthread")
endif ()

list(APPEND CMAKE_C_FLAGS ${PlatformFlag} ${PointerSizeFlag} ${CompilerFlag})
