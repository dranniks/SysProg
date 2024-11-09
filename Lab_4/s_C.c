#include <stdio.h>
#include <math.h>

int main() {
    int n, result = 0;
    scanf("%d", &n);
    for(int i = 0; i <= n; i++) {
        result += pow(-1, i - 1) * (i * i);
    }
    printf("%d\n", result);
    return 0;
}
