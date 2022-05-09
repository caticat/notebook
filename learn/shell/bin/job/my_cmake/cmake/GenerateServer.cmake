

MACRO(GENERATE_RUNTIME_SERVER SERVER_NAME SERVER_DIR)
    SET(SOURCES ${ARGN})	#工程源文件

    IF (USE_OPC)
        message("OPC_PROTOCOL : ${OPC_PROTOCOL} ${USE_OPC}")
        list(APPEND SOURCES ${OPC_PROTOCOL})
    ENDIF()

    #LUA PKG 依赖处理
    MESSAGE("USE_LUA_SCRIPT : ${USE_LUA_SCRIPT}")
	IF (USE_LUA_SCRIPT)
        FILE(GLOB_RECURSE TOLUA_SOURCES ${LUA_SCRIPT_SOURCES}) #${SHARED_PATH_DIR}/luascript/*.cpp
        SET( TOLUA_PACK_NAME "gamescript")
        SET( TOLUA_PKG "${CMAKE_CURRENT_SOURCE_DIR}/luapkg/gamescript.pkg")
        SET( TOLUA_CPP "${CMAKE_CURRENT_SOURCE_DIR}/script/${TOLUA_PACK_NAME}.cpp")
        SET( TOLUA_TMP_PKG "${CMAKE_CURRENT_SOURCE_DIR}/luapkg/.${TOLUA_PACK_NAME}.tmp.pkg")

        FILE(GLOB_RECURSE ALL_TOLUA_PKG ${CMAKE_CURRENT_SOURCE_DIR}/luapkg/*.pkg)
        FILE(STRINGS ${TOLUA_PKG} LUA_PKG_DEPEND_LIST REGEX ".*h\"")
        STRING(REGEX REPLACE "[^;]*(\"([^;]*h)\")[^;]*" "\\2" LUA_PKG_DEPEND "${LUA_PKG_DEPEND_LIST}")

        FILE(STRINGS ${TOLUA_PKG} LUA_PKG_FILE_STRING)
        STRING(REGEX REPLACE "(\\$[hclp]file) \"" "\n\n\\1 \"${CMAKE_CURRENT_SOURCE_DIR}/" 
        LUA_PKG_FILE_STRING ${LUA_PKG_FILE_STRING})

        LIST(APPEND SOURCES ${TOLUA_CPP})
        MESSAGE("ALL_TOLUA_PKG : ${ALL_TOLUA_PKG}")
        MESSAGE("TOLUA_CPP : ${TOLUA_CPP}")	
        MESSAGE("CMAKE_CURRENT_SOURCE_DIR : ${CMAKE_CURRENT_SOURCE_DIR}")
        MESSAGE("CMAKE_CURRENT_SOURCE_DIR : ${DIR_BIN}/${SERVER_DIR}")	

        ADD_CUSTOM_COMMAND(
            OUTPUT ${TOLUA_CPP}
            COMMAND ${TOLUA++_BIN}
            ARGS -n ${TOLUA_PACK_NAME} -o ${TOLUA_CPP} ${TOLUA_PKG}
            DEPENDS ${ALL_TOLUA_PKG} ${TOLUA++_BIN} ${LUA_PKG_DEPEND}
            WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/luapkg"
            )

        # ADD_CUSTOM_TARGET(copy_lua_scripts
        #     COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/lua ${DIR_BIN}/${SERVER_DIR}/lua
        # )
        # ADD_CUSTOM_TARGET(COPY_LUA_SCRIPTS)
        # ADD_CUSTOM_COMMAND(TARGET ${SERVER_NAME}
        #     POST_BUILD
        #     COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/lua ${DIR_BIN}/${SERVER_DIR}
        # )

        # ADD_CUSTOM_COMMAND(OUTPUT COPY_LUA_SCRIPTS
        #     COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/lua ${DIR_BIN}/${SERVER_DIR}/lua
        # )
    
    ENDIF()

    SET(LIB_COMMON "-lpthread -ltcmalloc -lcrypto -lpython2.7 -rdynamic -ldl -lz -lutil")
    # message("3PARTY_PATH_INCLUDE : ${3PARTY_PATH_INCLUDE}")
    INCLUDE_DIRECTORIES(
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${3PARTY_PATH_INCLUDE}
        ${SHARED_PATH_INC}        
    )

    LINK_DIRECTORIES(${DIR_BIN}/lib)
    LINK_DIRECTORIES(${3PARTY_PATH_LIB})
    # message("3PARTY_PATH_LIB Dir: ${3PARTY_PATH_LIB}")
    # 生成EXE
    ADD_EXECUTABLE(${SERVER_NAME} ${SOURCES} ${HEADS} ${COPY_LUA_SCRIPTS})

    SET_TARGET_PROPERTIES(${SERVER_NAME} PROPERTIES RUNTIME_OUTPUT_NAME "${SERVER_NAME}")
    SET_TARGET_PROPERTIES(${SERVER_NAME} PROPERTIES RUNTIME_OUTPUT_NAME_DEBUG "${SERVER_NAME}D")
    SET_TARGET_PROPERTIES(${SERVER_NAME} PROPERTIES RUNTIME_OUTPUT_NAME_RELEASE "${SERVER_NAME}R")
    SET_TARGET_PROPERTIES(${SERVER_NAME} PROPERTIES RUNTIME_OUTPUT_NAME_RELWITHDEBINFO "${SERVER_NAME}RD")
    SET_TARGET_PROPERTIES(${SERVER_NAME} PROPERTIES RUNTIME_OUTPUT_NAME_MINSIZEREL "${SERVER_NAME}MR")

    SET_TARGET_PROPERTIES(${SERVER_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${DIR_BIN}/${SERVER_DIR})
    SET_TARGET_PROPERTIES(${SERVER_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG ${DIR_BIN}/${SERVER_DIR})
    SET_TARGET_PROPERTIES(${SERVER_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE ${DIR_BIN}/${SERVER_DIR})
    SET_TARGET_PROPERTIES(${SERVER_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO ${DIR_BIN}/${SERVER_DIR})
    SET_TARGET_PROPERTIES(${SERVER_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL ${DIR_BIN}/${SERVER_DIR})

    INSTALL(TARGETS ${SERVER_NAME} DESTINATION ${SERVER_DIR})

    TARGET_LINK_LIBRARIES(${SERVER_NAME} PUBLIC ${LIB_SHARED})
    TARGET_LINK_LIBRARIES(${SERVER_NAME} PUBLIC ${LIB_COMMON})
    IF (USE_MYSQL)
        # fixed
        find_package(MySQL)
        if (MySQL_FOUND)
            TARGET_INCLUDE_DIRECTORIES(${SERVER_NAME} PUBLIC ${MySQL_INCLUDE_DIRS}/mysql)
            TARGET_LINK_LIBRARIES(
                ${SERVER_NAME} PUBLIC ${MySQL_LIBRARIES}
            )
        endif(MySQL_FOUND)
    ENDIF()

    IF (USE_LUA_SCRIPT)
        ADD_CUSTOM_COMMAND(TARGET ${SERVER_NAME}
            POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/lua ${DIR_BIN}/${SERVER_DIR}/lua
        )
    ENDIF()

ENDMACRO(GENERATE_RUNTIME_SERVER)


MACRO(SET_RUNTIME_MT)
	IF(MSVC)
		set(CompilerFlags
			CMAKE_CXX_FLAGS
			CMAKE_CXX_FLAGS_DEBUG
			CMAKE_CXX_FLAGS_RELEASE
			CMAKE_C_FLAGS
			CMAKE_C_FLAGS_DEBUG
			CMAKE_C_FLAGS_RELEASE
			)
		foreach(CompilerFlag ${CompilerFlags})
			string(REPLACE "/MD" "/MT" ${CompilerFlag} "${${CompilerFlag}}")
		endforeach()
	ENDIF(MSVC)
ENDMACRO(SET_RUNTIME_MT)