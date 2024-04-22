#include <stdio.h>

extern char *reversedigits(char *str);

int main(void)
{
    char input[100];

    printf("Enter a string with letters and numbers: ");
    scanf("%s", input);

    char *result = reversedigits(input);

    printf("Result: %s\n", result);
    return 0;
}