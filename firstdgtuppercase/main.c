#include <stdio.h>
#include <stdlib.h>

extern char *firstdgtuppercase(char *);

int main(void)
{
    char input[100];

    printf("Enter a string with a random digit somewhere: ");
    scanf("%[^\n]", input);

    char *result = firstdgtuppercase(input);

    printf("Result: %s\n", result);
    return 0;
}