#include <stdio.h>

/* Verify that the expression `getchar() != EOF` is 0 or 1. */

int main() {
    printf("%d\n", getchar() != EOF);
    return 0;
}
