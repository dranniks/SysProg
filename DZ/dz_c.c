#include<stdio.h>

unsigned long * qNew();
unsigned long * qDelete();
unsigned long * qPush(int number);
unsigned long * qPop();
unsigned long * qFillRandom(int lenght);
unsigned long * qCountEndingWithOne();
unsigned long * qCountEvenNumbers();
unsigned long * qCountPrimeNumbers();

int main(){
    unsigned long * q;
    q = qNew();
    qPush(1);
    qPush(11);
    qPush(17);
    qPush(38);
    qPush(46);
    qPush(115);
    qPush(899);
    qPush(0);

    printf("%s", "Количество простых чисел: ");
    printf("%ld\n",qCountPrimeNumbers());                       // 1, 11, 17
    printf("%s", "Количество чисел, оканчивающихся на '1': ");
    printf("%ld\n",qCountEndingWithOne());                      // 1, 11
    printf("%s", "Количество четных чисел: ");
    printf("%ld\n",qCountEvenNumbers());                        // 38, 46, 0
    printf("%s\n", "Значения очереди: ");
    printf("%ld\n",qPop());
    printf("%ld\n",qPop());
    printf("%ld\n",qPop());
    printf("%ld\n",qPop());
    printf("%ld\n",qPop());
    printf("%ld\n",qPop());
    printf("%ld\n",qPop());
    printf("%ld\n",qPop());
    
    printf("%s\n", "Пример заполнения случайными значениями: ");
    qFillRandom(5);
    printf("%ld\n",qPop());
    printf("%ld\n",qPop());
    printf("%ld\n",qPop());
    printf("%ld\n",qPop());
    printf("%ld\n",qPop());
    qDelete();
    return 0;
}