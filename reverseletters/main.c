#include <stdio.h>

extern char *reverseletters(char *str);

int main(void)
{
    char input[100];

    printf("Enter a string with letters and numbers: ");
    scanf("%s", input);

    char *result = reverseletters(input);

    printf("Result: %s\n", result);
    return 0;
}