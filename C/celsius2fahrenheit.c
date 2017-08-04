#include <stdio.h>

/* print Fahrenheit-Celsius table
    for fahr = 0, 20,  ..., 300; floating-point version */

main()
{
    float fahr, celsius;
    int lower, upper, step;

    lower = 0;
    upper = 300;
    step = 20;

    celsius = lower;

    printf("Celsius | Fahrenheit\n");
    printf("------- | ----------\n");

    while (celsius <= upper) {
        fahr = celsius * (9.0 / 5.0) + 32.0;
        printf("%3.0f %6.1f\n", celsius, fahr);
        celsius = celsius + step;
    }


}

