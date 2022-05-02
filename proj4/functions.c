// Alan Nguyen CK38254, Peter Scrandis WO68214

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

// function for displatying all the arrays
void display(char *arr[]){ // s Or S
    for (int z = 0; z < 10; z++){
        printf("Message[%d]: %d \n",z, arr[z]);
    }
}

// function used to add words to the arrays
// maybe change return type to help keep track of which message is being changed??
int read(char *arr[], int position){ //r or R

    /*
    if (arr[0] = ""){
         for (int z = 0; z < 10; z++){
            arr[z] = "This is the original Message.";
        }
    }
    */

    char word[1000];

    printf("Enter your message: ");
    scanf("%s",word);

    int Length = strlen(word);

    if (isupper(word[0]) == 1){
        if (word[Length-1] == "!" && word[Length-1] == "." && word[Length-1] == "?"){
            arr[position] = word;
            
            if (position == 9) position = 0;

            else position++;

        }
        
        else {
            printf("Invalid Message, Keeping Curent");           
        }
    }

    else{
        printf("Invalid Message, Keeping Curent");
    }     
    
    return position;
}

void decrypt(char *arr[]){ // f or F

}

// for testing maybe? Idk how this works
int main(){
    char test[10][1000];
    int position = 0;
    char temp = "hello";
    char temp2 = "Hello";
    read(temp2, test ,position);
    read(temp2, test ,position);
    display(test);
    return 0;

}