#include <stdio.h>

int main() {
    int n, yes_count = 0, no_count = 0, vote;

    printf("Enter the number of judges: ");
    scanf("%d", &n);

    for (int i = 0; i < n; i++) {
        scanf("%d", &vote);
        if (vote == 1) { yes_count++; } 
        else { no_count++; }
    }
    if (yes_count > no_count) {
        printf("Votes 'Yes' more.\n");
    } else if (no_count > yes_count) {
        printf("Votes 'No' more.\n");
    } else {
        printf("Number of votes 'Yes' and 'No' is equal.\n");
    }
    return 0;
}
