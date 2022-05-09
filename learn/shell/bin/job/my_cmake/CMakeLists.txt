cmake_minimum_required(VERSION 3.5)

project(gamename)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/AutoCollect.cmake)

add_definitions(-D__LINUX__)
add_compile_options(-g -O0 -std=c++11 -Wno-deprecated-register -Wno-deprecated-declarations -Wno-inconsistent-missing-override -Wno-overloaded-virtual -Wno-format-security)
set(CMAKE_EXE_LINKER_FLAGS "-Wl,-export-dynamic")

add_subdirectory(protobuf)
add_subdirectory(gamename)
add_subdirectory(GateServer)
add_subdirectory(WorldServer)
