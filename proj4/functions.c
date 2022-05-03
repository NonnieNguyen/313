// Alan Nguyen CK38254, Peter Scrandis WO68214

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>

// function for displatying all the arrays
void display(char *arr[]){ // s Or S
    // for loop iterates through the arrays and prints all the messages
    for (int z = 0; z < 10; z++){
        printf("Message[%d]: %d \n",z, arr[z]);
    }
}

// function used to add words to the arrays
// maybe change return type to help keep track of which message is being changed??
int read(char *arr[], int position){ //r or R

    /*
    printf("."); // for testing purposes

    if (arr[0] = ""){
         for (int z = 0; z < 10; z++){
            arr[z] = "This is the original Message.";
        }
    }
    printf(","); // for testing purposes
    */

    char word[1000];
    printf("Enter your message: ");
    scanf("%s",word);

    int Length = strlen(word);

    // if statments check if the first Letter is uppercase, and the char before newline is 
    if (isupper(word[0]) == 1){ 
        if (&word[Length-1] == "!" && &word[Length-1] == "." && &word[Length-1] == "?"){
            arr[position] = word;
            
            // if the message is added checks which message was changed and moves to the next one
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

// function for the frequency cypher
void decrypt(char *arr[]){ // f or F
    char Most_Used[5] = FindFrequency(arr);

}

// function used for finding the most used letters in the message
char FindFrequency(char arr[]){
    int counter = 0;
    int frequency[26] = {0};
    char Most_Used[5];
    
    // function iterates through the message checking howmany times the letters were used
    while(arr[counter] != '\n'){
            frequency[ arr[counter] - 'a']++; // (- 'a') is for converting it into ascii? maybe 
            counter++;
    }

    counter = 0;

    // for loop used for for iterating through array to find most used letters
    for (int i = 0; i < 26; i++) {
        if (frequency[i] != 0) {
            // temp print used to see which letters are the most common
            printf("%c : %d\n",i + 'a', frequency[i]); // (+ 'a') is for converting it from ascii? maybe 

            // adds the 5 most used letters into an array
            if (counter < 5){
                // some way to compare the sizes

                Most_Used[counter] = i + 'a';

                counter++;
            }

            
        }
    }

    return Most_Used;
}

