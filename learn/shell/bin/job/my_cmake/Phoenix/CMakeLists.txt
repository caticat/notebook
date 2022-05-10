project(gamename.out)

CollectSourceFiles(${CMAKE_SOURCE_DIR}/net SRCS)
CollectSourceFiles(${CMAKE_SOURCE_DIR}/base SRCS)
CollectSourceFiles(${CMAKE_CURRENT_SOURCE_DIR} SRCS)

#message(STATUS ${SRCS})

add_executable(${PROJECT_NAME} ${SRCS})

target_include_directories(${PROJECT_NAME}
        PRIVATE ${CMAKE_SOURCE_DIR}
        PRIVATE /usr/include/mysql
        PRIVATE /home/pan/workspace/server/lib3rd/lua-5.3.5/include
        PRIVATE /home/pan/workspace/server/lib3rd/tolua++-1.0.93/include
        )

target_link_directories(${PROJECT_NAME}
        PRIVATE /usr/lib64
        PRIVATE /home/pan/.lib
        PRIVATE /usr/local/lib
        PRIVATE /usr/lib64/mysql
        )

target_link_libraries(${PROJECT_NAME}
        PRIVATE asan
        PRIVATE z
        PRIVATE dl
        PRIVATE PB
        PRIVATE lua
        PRIVATE curl
        PRIVATE crypto
        PRIVATE tolua++
        PRIVATE jsoncpp
        PRIVATE pthread
        PRIVATE tcmalloc
        PRIVATE python2.7
        PRIVATE log4cplus
        PRIVATE mysqlclient
        )

# Address Sanitizer内存检查
# target_compile_options(${PROJECT_NAME}
#         PRIVATE -fsanitize=address -fno-omit-frame-pointer
#         )

# 结束后执行脚本
add_custom_command(
        TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND /home/pan/.bin/pan.sh ub Phoenix/${PROJECT_NAME}
)
