#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern char *removeoutsidebrackets(char *str);
extern int removeoutsidebracketslen(char *str);

int main(int argc, char *argv[])
{
    char input[100];

    if (argc > 2)
    {
        printf("Usage: %s <string>\n", argv[0]);
        return 1;
    }

    if (argc == 2)
    {
        strcpy(input, argv[1]);
    }
    else
    {
        printf("Enter a string with brackets ([]): ");
        scanf("%[^\n]", input);
    }

    printf("(BEFORE) Input: %s\n", input);

    char *strresult = removeoutsidebrackets(input);
    int result = removeoutsidebracketslen(input);

    printf("(AFTER) Input: %s\n", input);
    printf("Result: %s\n", strresult);
    printf("Length: %d\n", result);

    return 0;
}