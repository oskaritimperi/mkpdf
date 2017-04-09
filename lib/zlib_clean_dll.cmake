FILE(GLOB dll
    ${STAGE_DIR}/lib/libz*.so*
    ${STAGE_DIR}/lib/zlib*.dll
)

FILE(REMOVE ${dll})
