cmake_minimum_required(VERSION 3.5)

project(app2)

aux_source_directory(. SRCS)

add_executable(${PROJECT_NAME} ${SRCS})

target_include_directories(${PROJECT_NAME}
	PRIVATE ${CMAKE_SOURCE_DIR}
)

target_link_libraries(${PROJECT_NAME}
	PRIVATE calc
)
