#include<stdio.h>

unsigned long * new_queue();
unsigned long * del_queue();
unsigned long * q_push(int n);
unsigned long * q_pop();

int main(){
    unsigned long *p;
    p = new_queue();
    q_push(1);
    printf("%ld\n",q_pop());

    q_push(2);
    q_push(3);
    printf("%ld\n",q_pop());
    printf("%ld\n",q_pop());
    q_push(2);
    q_push(3);
    del_queue();
    q_push(4);
    q_push(5);
    
    q_push(9);q_push(9);q_push(9);
    printf("%ld\n",q_pop());
    printf("%ld\n",q_pop());
    return 0;
}