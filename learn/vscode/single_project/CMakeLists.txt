cmake_minimum_required(VERSION 3.5)

project(playground)

add_compile_options(-g -O0 -std=c++11)
set(CMAKE_EXE_LINKER_FLAGS "-Wl,-export-dynamic")

aux_source_directory(. SRCS)

add_executable(${PROJECT_NAME} ${SRCS})
