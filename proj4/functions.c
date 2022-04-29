// Alan Nguyen CK38254, Peter Scrandis WO68214

#include <stdio.h>

void display(int *arr[]){
    for (int z = 0; z < 10; z++){
        printf("Message[%d]: %d \n",z, arr[z]);
    }
}