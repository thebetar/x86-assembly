#include <stdio.h>
#include <stdlib.h>

extern char *betweenasttoupper(char *);

int main(void)
{
    char input[100];

    printf("Enter a string: ");
    scanf("%s", input);

    char *result = betweenasttoupper(input);

    printf("Result: %s\n", result);
    return 0;
}