#include <stdio.h>
#include <stdlib.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

#define OPTPARSE_IMPLEMENTATION
#define OPTPARSE_API static
#include "optparse.h"

int luaopen_hpdf(lua_State *L);

extern const char mkpdf_lua[];
extern const unsigned long mkpdf_lua_size;

void usage(const char *program)
{
    fprintf(stderr, "%s [--version] [--help] <script-path>\n", program);
}

int main(int argc, char **argv)
{
    lua_State *L;
    int rc = 0;
    int option = 0;
    struct optparse optparse;
    const char *script;

    const struct optparse_long options[] =
    {
        { "version", 'v', OPTPARSE_NONE },
        { "help", 'h', OPTPARSE_NONE },
        { NULL }
    };

    optparse_init(&optparse, argv);

    while ((option = optparse_long(&optparse, options, NULL)) != -1)
    {
        switch (option)
        {
            case 'v':
                printf("%s\n", MKPDF_VERSION);
                return 0;

            case 'h':
                usage(argv[0]);
                return 1;

            case '?':
                fprintf(stderr, "%s\n", optparse.errmsg);
                usage(argv[0]);
                return 1;
        }
    }

    if ((script = optparse_arg(&optparse)) == NULL)
    {
        fprintf(stderr, "error: no script given\n\n");
        usage(argv[0]);
        return 1;
    }

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
