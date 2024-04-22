#include <stdio.h>

char *removerep(char *str)
{
    char *src = str;
    char *dst = str;

    char lastchar = '\0';

    while (*src)
    {
        if (*src != lastchar)
        {
            *dst = *src;
            lastchar = *src;
            dst++;
        }
        src++;
    }

    *dst = '\0';

    return str;
}

int main()
{
    char str[] = "aabbccddeeff";
    char *result = removerep(str);

    printf("Result: %s\n", result);
    return 0;
}