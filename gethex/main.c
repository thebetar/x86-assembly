#include <stdio.h>
#include <stdlib.h>

extern char *gethex(char *);

int main(void)
{
    char input[100];

    printf("Enter a hex string: ");
    scanf("%s", input);

    char *result = gethex(input);

    int hexresult = (int)strtol(result, NULL, 16);

    printf("Result string: %s\n", result);
    printf("Result decimal: %d\n", hexresult);
}