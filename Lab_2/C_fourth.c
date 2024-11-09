# include <stdio.h>
int main() {
    int number = 1019734634; char sum = 0;    
    for (;number; number /= 10) sum += number % 10;    
    printf("%d\n", sum);
    return 0;
}