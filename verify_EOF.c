#include <stdio.h>

/* Verify that the expression `getchar() != EOF` is 0 or 1. */

main() {
    printf("%d\n", getchar() != EOF);
}
