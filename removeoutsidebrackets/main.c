#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern char *removeoutsidebrackets(char *str);
extern int removeoutsidebracketslen(char *str);

int main(void)
{
    char input[100];

    printf("Enter a string with brackets ([]): ");
    scanf("%[^\n]", input);

    char *strresult = removeoutsidebrackets(input);
    int result = removeoutsidebracketslen(input);

    printf("Result: %s\n", strresult);
    printf("Length: %d\n", result);

    return 0;
}