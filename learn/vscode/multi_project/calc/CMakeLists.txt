cmake_minimum_required(VERSION 3.5)

project(calc)

aux_source_directory(. SRCS)

add_library(${PROJECT_NAME} SHARED ${SRCS})
