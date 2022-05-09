cmake_minimum_required(VERSION 3.5)

project(mutily_project)

add_compile_options(-g -O0 -std=c++11)
set(CMAKE_EXE_LINKER_FLAGS "-Wl,-export-dynamic")

# aux_source_directory(. SRCS)

add_subdirectory(app)
add_subdirectory(app2)
add_subdirectory(calc)
