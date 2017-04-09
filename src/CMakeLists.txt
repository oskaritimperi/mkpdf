FIND_LIBRARY(hpdfs hpdfs PATHS ${PROJECT_SOURCE_DIR}/lib/stage/lib)
FIND_LIBRARY(lua lua  PATHS ${PROJECT_SOURCE_DIR}/lib/stage/lib)
FIND_LIBRARY(luahpdf luahpdf  PATHS ${PROJECT_SOURCE_DIR}/lib/stage/lib)
FIND_LIBRARY(z z)
FIND_LIBRARY(png png)

ADD_EXECUTABLE(bin2c bin2c.c)

ADD_CUSTOM_COMMAND(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/mkpdf.lua.c
    COMMAND bin2c ${CMAKE_CURRENT_SOURCE_DIR}/mkpdf.lua ${CMAKE_CURRENT_BINARY_DIR}/mkpdf.lua.c
    DEPENDS mkpdf.lua
)

ADD_EXECUTABLE(mkpdf main.c ${CMAKE_CURRENT_BINARY_DIR}/mkpdf.lua.c)

TARGET_LINK_LIBRARIES(mkpdf PRIVATE ${luahpdf} ${lua} ${hpdfs} ${z} ${png} m)

TARGET_INCLUDE_DIRECTORIES(mkpdf PRIVATE ${PROJECT_SOURCE_DIR}/lib/stage/include)
