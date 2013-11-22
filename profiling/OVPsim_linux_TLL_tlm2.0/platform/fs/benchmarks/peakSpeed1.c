#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NOINLINE __attribute__((noinline))

int main()
{
    int a=0, b=1, c=2, d=3, e=4, f=5, g=6, h=7,
        i=8, j=9, k=10, l=11, m=12, n=13, o=14, p=15;
    int count, result;

    for(count=0; count<400000000; count++) {

        a = i;
        b = j;
        c = k;
        d = l;
        e = m;
        f = n;
        g = o;
        h = p;

        i = a;
        j = e;
        k = b;
        l = f;
        m = c;
        n = g;
        o = d;
        p = h;
    }

    result = a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p;

    printf("result=%d\n", result);

    return result;
}
