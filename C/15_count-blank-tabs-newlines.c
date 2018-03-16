#include <stdio.h>

/* Count blanks, tabs and newlines */

int main()
{
	int c, nb, nt, nl;
	
	nb = nt = nl = 0;
	while ((c = getchar()) != EOF){
		if (c == ' '){
			++nb;
		}
		if (c == '\t'){
			++nt;
		}
		if (c == '\n'){
			++nl;
		}
	}
	printf("\nBlanks: %d | Tabs: %d | Newlines: %d\n", nb, nt, nl);
	return 0;
}
