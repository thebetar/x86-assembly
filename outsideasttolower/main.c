#include <stdio.h>
#include <stdlib.h>

extern char *outsideastlower(char *);

int main(void)
{
    char input[100];

    printf("Enter a string: ");
    scanf("%[^\n]", input);

    char *result = outsideastlower(input);

    printf("Result: %s\n", result);
    return 0;
}