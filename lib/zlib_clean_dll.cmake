FILE(GLOB dll
    ${STAGE_DIR}/lib/libz*.so*
    ${STAGE_DIR}/bin/zlib*.dll
)

FILE(REMOVE ${dll})
