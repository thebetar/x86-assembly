#include <stdio.h>
#include <ctype.h>

extern char *removerep(char *);

int main(int argc, char **argv)
{
    if (argc != 2)
    {
        fprintf(stderr, "Usage: %s <string>\n", argv[0]);
        return 1;
    }

    char *str = argv[1];

    char *result = removerep(str);

    printf("Result: %s\n", result);
    return 0;
}