#include <stdio.h> 

/* Count characters in input. v1 */

int main()
{
    long nc;

    nc = 0;
    while (getchar() != EOF)
        ++nc;
    printf("%ld\n", nc);
	return 0;    
}
