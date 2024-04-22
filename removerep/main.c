#include <stdio.h>
#include <ctype.h>

extern char *removerep(char *);

int main(void)
{
    char str[] = "aabbccddeeff";

    char *result = removerep(str);

    printf("Result: %s\n", result);
    return 0;
}