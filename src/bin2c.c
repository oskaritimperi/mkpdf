#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <ctype.h>

static char *id(const char *s)
{
    char *r;
    char *b = (char *) strrchr(s, '/');
    if (!b)
        b = (char *) strrchr(s, '\\');
    if (!b)
        b = (char *) s;
    else
        ++b;
    b = strdup(b);
    r = b;
    while (*r)
    {
        if (!isalnum(*r))
        {
            *r = '_';
        }
        ++r;
    }
    if (!isalpha(*b))
    {
        *b = '_';
    }
    return b;
}

int main(int argc, char** argv) {
    assert(argc >= 2);

    char* fn = argv[1];

    char *outfn = NULL;
    if (argc > 2)
        outfn = argv[2];

    char *varname = id(fn);

    FILE* f = fopen(fn, "r");
    FILE *fout;

    if (!outfn)
        fout = stdout;
    else
        fout = fopen(outfn, "w");

    fprintf(fout, "const char %s[] = {\n", varname);
    unsigned long n = 0;
    while(!feof(f)) {
        unsigned char c;
        if(fread(&c, 1, 1, f) == 0) break;
        fprintf(fout, "%s0x%.2X", (n > 0) ? "," : "", (int)c);
        ++n;
        if(n % 10 == 0) fprintf(fout, "\n");
    }
    fprintf(fout, ",0x00};\n");
    fprintf(fout, "const unsigned long %s_size = %lu;\n", varname, n);

    fclose(fout);
    fclose(f);
}
