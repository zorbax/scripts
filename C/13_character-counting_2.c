#include <stdio.h> 

/* Count characters in input. v2 */

int main()
{
    double nc;

    nc = 0;
    for (nc = 0; getchar() != EOF; ++nc)
        ;
    printf("%.0f\n", nc);
    return 0;
}
