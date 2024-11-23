cmake_minimum_required(VERSION 3.15)

if(WIN32)
    add_subdirectory(windows)
else (UNIX)
    add_subdirectory(linux)
endif ()
