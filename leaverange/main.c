#include <stdio.h>

extern char *leaverange(char *str, char a, char b);

int main(int argc, char **argv)
{
    if (argc != 4)
    {
        printf("Usage is <string> <char1> <char2>");
        return 1;
    }

    char *s = argv[1];
    char a = argv[2][0];
    char b = argv[3][0];

    printf("Inputs: %s, %c, %c\n", s, a, b);

    char *result = leaverange(s, a, b);

    printf("Result: %s\n", result);
    return 0;
}