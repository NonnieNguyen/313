// Alan Nguyen CK38254, Peter Scrandis WO68214

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

// function for displatying all the arrays
void display(char *arr[]){ // s Or S
    for (int z = 0; z < 10; z++){
        printf("Message[%d]: %d \n",z, arr[z]);
    }
}

// function used to add words to the arrays
// maybe change return type to help keep track of which message is being changed??
void read(char *arr[],char word[], int place){ //r or R
    if (arr[0 == ""]){
         for (int z = 0; z < 10; z++){
             arr[z] = "This is the original Message.";
        }
    }

    else{
        int Length = strlen(word);
        if (isupper(word[0]) == 1){
            if (word[Length-1] == "!" && word[Length-1] == "." && word[Length-1] == "?"){
                arr[place] = word;
            }

            else {
                printf("Your message does not end with a punctuation mark ");
            }
        }

        else{
            printf("Your message does not start with a captial Letter");
        }
    }
}

void decrypt(char *arr[]){ // f or F

}

// for testing maybe? Idk how this works
int main(){
    int place = 2;
    char temp = "hello";
    char temp2 = "Hello";
    char words[10][1000];
    read(words, temp, place);
    display(words);
    return 0;

}