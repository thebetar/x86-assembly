#include <stdio.h>
#include <stdlib.h>

extern char *removenthchar(char *, int);

int main(int argc, char **argv)
{
    if (argc > 3 || argc < 3)
    {
        printf("Usage is <string> <int>");
        return 1;
    }

    char *str = argv[1];
    char nth = atoi(argv[2]);

    char *result = removenthchar(str, nth);

    printf("Result: %s\n", result); // Expected: Helo (index 2 is 'l'

    return 0;
}