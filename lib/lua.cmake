CMAKE_MINIMUM_REQUIRED(VERSION 3.0)
PROJECT(lua C)

SET(CORE_SRC
    src/lapi.c src/lcode.c src/lctype.c src/ldebug.c src/ldo.c src/ldump.c src/lfunc.c src/lgc.c src/llex.c
    src/lmem.c src/lobject.c src/lopcodes.c src/lparser.c src/lstate.c src/lstring.c src/ltable.c
    src/ltm.c src/lundump.c src/lvm.c src/lzio.c
)

SET(LIB_SRC
    src/lauxlib.c src/lbaselib.c src/lbitlib.c src/lcorolib.c src/ldblib.c src/liolib.c
    src/lmathlib.c src/loslib.c src/lstrlib.c src/ltablib.c src/lutf8lib.c src/loadlib.c src/linit.c
)

ADD_LIBRARY(lua STATIC ${CORE_SRC} ${LIB_SRC})

TARGET_COMPILE_DEFINITIONS(lua PRIVATE -DLUA_COMPAT_5_2)

IF(CMAKE_COMPILER_IS_GNUCC)
    TARGET_COMPILE_OPTIONS(lua PRIVATE -std=gnu99)
ENDIF()

IF(NOT WIN32)
    TARGET_LINK_LIBRARIES(lua PUBLIC m)
ENDIF()

IF(CMAKE_SYSTEM_NAME STREQUAL Linux)
    TARGET_COMPILE_DEFINITIONS(lua PUBLIC -DLUA_USE_LINUX)
    TARGET_LINK_LIBRARIES(lua PUBLIC dl)
ELSEIF(CMAKE_SYSTEM_NAME STREQUAL Darwin)
    TARGET_COMPILE_DEFINITIONS(lua PUBLIC -DLUA_USE_MACOSX)
ENDIF()

INSTALL(TARGETS lua EXPORT lua-targets DESTINATION lib)

INSTALL(FILES src/lua.h src/luaconf.h src/lualib.h src/lauxlib.h src/lua.hpp DESTINATION include)

INSTALL(EXPORT lua-targets FILE lua-config.cmake DESTINATION lib/cmake/lua)
