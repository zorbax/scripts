#include <stdio.h>

int c;

int main(){
	while ((c = getchar()) != EOF) {
		if (c == ' ') {
			while ((c = getchar()) == ' ')
				;
			putchar(' ');
		}
    putchar(c);
	}
	return 0;
}

