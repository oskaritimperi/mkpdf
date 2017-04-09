CMAKE_MINIMUM_REQUIRED(VERSION 3.0)
PROJECT(lib)

INCLUDE(ExternalProject)

ExternalProject_Add(lua
    URL https://www.lua.org/ftp/lua-5.3.4.tar.gz
    URL_HASH SHA1=79790cfd40e09ba796b01a571d4d63b52b1cd950
    PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/lua.cmake <SOURCE_DIR>/CMakeLists.txt
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_SOURCE_DIR}/stage
)

ExternalProject_Add(libharu
    GIT_REPOSITORY https://github.com/libharu/libharu.git
    GIT_TAG d84867ebf9f3de6afd661d2cdaff102457fbc371
    CMAKE_ARGS -DLIBHPDF_SHARED=OFF -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_SOURCE_DIR}/stage
)

ExternalProject_Add(luahpdf
    GIT_REPOSITORY https://github.com/jung-kurt/luahpdf.git
    GIT_TAG d8c93345d87a96135739017566d98b02774f558a
    DEPENDS lua libharu
    PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/luahpdf.cmake <SOURCE_DIR>/CMakeLists.txt
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_SOURCE_DIR}/stage
)
