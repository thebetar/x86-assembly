#include <stdio.h>
#include <stdlib.h>
// #include "removerange.h"

extern char *removerange(char *str, char a, char b);

int main(int argc, char *argv[])
{
    if (argc > 4 || argc < 4)
    {
        printf("Usage is <string> <char1> <char2>");
        return 1;
    }

    char *s = argv[1];
    char a = argv[2][0];
    char b = argv[3][0];

    char *result = removerange(s, a, b);

    printf("Result: %s\n", result);

    return 0;
}