#include <stdio.h>
#include <math.h>

int main() {
    int k, result = 0;
    scanf("%d", &k);
    for(int i = 0; i <= k; i++) {
        result += pow(-1, i) * i * (i + 1) * (3*i + 1) * (3*i + 2);
    }
    printf("%d\n", result);
    return 0;
}