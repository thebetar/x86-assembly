#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int leavelastndgt(char *, int);

int main(int argc, char *argv[])
{
    if (argc != 3)
    {
        printf("Usage: %s <string> <int>\n", argv[0]);
        exit(1);
    }

    char *str = argv[1];
    int n = atoi(argv[2]);

    if (strlen(str) < n)
    {
        printf("The string is shorter than the number of digits to leave\n");
        exit(1);
    }

    int result = leavelastndgt(str, n);

    printf("Result: %s\n", result);
    return 0;
}