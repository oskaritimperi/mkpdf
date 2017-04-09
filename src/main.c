#include <stdio.h>
#include <stdlib.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

int luaopen_hpdf(lua_State *L);

extern const char mkpdf_lua[];
extern const unsigned long mkpdf_lua_size;

int main(int argc, char **argv)
{
    lua_State *L;
    int rc = 0;

    L = luaL_newstate();

    luaL_openlibs(L);

    lua_getglobal(L, "package");
    lua_getfield(L, -1, "preload");
    lua_pushcfunction(L, luaopen_hpdf);
    lua_setfield(L, -2, "hpdf");
    lua_pop(L, 2);

    if (luaL_dostring(L, mkpdf_lua))
    {
        fprintf(stderr, "%s\n", lua_tostring(L, -1));
        rc = 1;
    }

    if (luaL_dofile(L, argv[1]))
    {
        fprintf(stderr, "%s\n", lua_tostring(L, -1));
        rc = 1;
    }

    lua_close(L);

    return rc;
}
