// Alan Nguyen CK38254, Peter Scrandis WO68214

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
struct Messages{
    char messages[10][1000]; 
    int position;

};

// function for displatying all the arrays
void display(struct Messages test){ // s Or S
    for (int z = 0; z < 10; z++){
        printf("Message[%d]: %d \n",z, test.messages[z]);
    }
}

// function used to add words to the arrays
// maybe change return type to help keep track of which message is being changed??
void read(struct Messages test, char word[]){ //r or R
    if (*test.messages[0] = ""){
         for (int z = 0; z < 10; z++){
            *test.messages[z] = "This is the original Message.";
        }
    }

    else{
        int Length = strlen(word);
        if (isupper(word[0]) == 1){
            if (word[Length-1] == "!" && word[Length-1] == "." && word[Length-1] == "?"){
                *test.messages[test.position] = word;
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
    struct Messages test;

    test.position = 0;
    char temp = "hello";
    char temp2 = "Hello";
    read(test, temp);
    display(test);
    return 0;

}