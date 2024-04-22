#include <stdio.h>
#include <stdlib.h>

extern char *shortestgroupupper(char *);

int main(void)
{
    char input[100];

    printf("Enter a string: ");
    scanf("%[^\n]", input);

    char *result = shortestgroupupper(input);

    printf("Result: %s\n", result);
    return 0;
}