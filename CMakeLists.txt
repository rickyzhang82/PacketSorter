project(PacketSorter)
cmake_minimum_required(VERSION 3.4.3)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# CMake useful variables
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")

# hints pkgconfig path
set(ENV{PKG_CONFIG_PATH} "$ENV{PKG_CONFIG_PATH}:$ENV{SYSROOT}/usr/local/lib/pkgconfig")

set(VERSION_MAJOR "0")
set(VERSION_MINOR "0")
set(VERSION_PATCH "0")
set(VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH})

include(Common)

option(BUILD_TESTS "Build PacketSorter perftests and unittests." ON)

# the `pkg_check_modules` function is created with this call
find_package(PkgConfig REQUIRED)
# PcapPlusPlus package
pkg_check_modules(PCAPPLUSPLUS REQUIRED PcapPlusPlus)
# threading package
find_package(Threads REQUIRED)
# Coverage report
find_package(codecov)

# Mac needed variables (adapt for your needs - http://www.cmake.org/Wiki/CMake_RPATH_handling#Mac_OS_X_and_the_RPATH)
set(CMAKE_MACOSX_RPATH ON)
set(CMAKE_SKIP_BUILD_RPATH FALSE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

#enable_testing()

###########################################################################
# build main program
###########################################################################
set(APPLICATION_NAME PacketSorter)
set(SOURCE src/main.cpp)

include_directories(${PCAPPLUSPLUS_INCLUDE_DIRS})

add_executable(${APPLICATION_NAME} ${SOURCE})

target_link_libraries(${APPLICATION_NAME} ${PCAPPLUSPLUS_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT})

install(TARGETS ${APPLICATION_NAME}
  EXPORT ${PROJECT_NAME}Targets            # for downstream dependencies
  ARCHIVE DESTINATION lib COMPONENT libs   # static lib
  RUNTIME DESTINATION bin COMPONENT libs   # binaries
  LIBRARY DESTINATION lib COMPONENT libs   # shared lib
  FRAMEWORK DESTINATION bin COMPONENT libs # for mac
  PUBLIC_HEADER DESTINATION include/${PROJECT_NAME} COMPONENT devel   # headers for mac (note the different component -> different package)
  INCLUDES DESTINATION include             # headers
)

#add_subdirectory(test)

#
# SYSTEM PACKAGING (RPM, TGZ, ...)
# _____________________________________________________________________________

include(CPackConfig)

coverage_evaluate()
