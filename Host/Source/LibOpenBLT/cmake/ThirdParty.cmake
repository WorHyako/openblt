cmake_minimum_required(VERSION 3.15)

# Under Unix the LibUsb library (http://libusb.info/) is needed for the USB support.
# Make sure the libusb-1.0-0 and  libusb-1.0-0-dev packages are installed to be able
# to build LibOpenBLT. Example under Debian/Ubuntu:
#   sudo apt-get install libusb-1.0-0 libusb-1.0-0-dev
# ---------- #
#   libusb   #
# ---------- #
find_package(PkgConfig REQUIRED)
pkg_check_modules(libusb REQUIRED IMPORTED_TARGET libusb-1.0)

# ------------------------ #
#   Collect OS libraries   #
# ------------------------ #
add_library(OsLibs INTERFACE)
add_library(openblt::osLibs ALIAS OsLibs)

if (WIN32)
    find_library(SetupApi REQUIRED
            NAMES setupapi)
    find_library(Ws2_32 REQUIRED
            NAMES ws2_32)
    find_library(WinUsb REQUIRED
            NAMES winusb)

    target_link_libraries(OsLibs
            INTERFACE
            ${SetupApi}
            ${Ws2_32}
            ${WinUsb})
elseif (UNIX)
    # Additionally, the LibDL is needed for dynamic library loading.
    find_library(Dl REQUIRED
            NAMES dl)

    target_link_libraries(OsLibs
            INTERFACE ${Dl})
endif ()
