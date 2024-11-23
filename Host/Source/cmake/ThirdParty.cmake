cmake_minimum_required(VERSION 3.15)

# Under Unix the LibUsb library (http://libusb.info/) is needed for the USB support.
# Make sure the libusb-1.0-0 and  libusb-1.0-0-dev packages are installed to be able
# to build LibOpenBLT. Example under Debian/Ubuntu:
#   sudo apt-get install libusb-1.0-0 libusb-1.0-0-dev
# Additionally, the LibDL is needed for dynamic library loading.
find_package(PkgConfig REQUIRED)
pkg_check_modules(libusb REQUIRED IMPORTED_TARGET libusb-1.0)
