#include <stdio.h>

extern int add(int, int);

int main(void)
{
    int result = add(1, 2);

    printf("Result: %d\n", result);
    return 0;
}