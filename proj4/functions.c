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
        printf("Message[%d]: %s \n", z, arr[z]);
    }
}

// function used to add words to the arrays
// maybe change return type to help keep track of which message is being changed??
int read(char *arr[], int position){ //r or R
    char word[1000];
    printf("Enter your message: ");
    scanf("%[^\n]s", &word);

    int Length = strlen(word);

    // if statments check if the first Letter is uppercase, and the char before newline is ! ? .
    if (isupper(word[0])){ 
        if (word[Length-1] == '!' || word[Length-1] == '.' || word[Length-1] == '?'){
            free(arr[position]);
            arr[position] = malloc(Length);
            
            for (int i = 0; i < Length; i++) {
                *(arr[position] + i) = word[i];
            }
            // if the message is added checks which message was changed and moves to the next one
            if (position == 9) position = 0; 
            else position++;
        }
        
        else {
            printf("Invalid Message, Keeping Curent \n");           
        }
    }

    else{
        printf("Invalid Message, Keeping Curent \n");
    }     
    
    return position;
}


// function for the frequency cypher
void decrypt(char *arr[]){ // f or F
    char FREQ[5] = {'e','t','a','o','i'};
    int counter = 0, location, checker, Max = 0, Length, shift;
    int frequency[26] = {0};
    char Most_Used[5], letter;
    
    printf("Enter string location : ");
    scanf("%d",&location);
    Length = strlen(arr[location]);

    // for loop used for counting the frequency of letters in the message
    for (int z = 0; z < Length; z++){        
        frequency[ arr[location][z] - 'a']++; // gets how far the letter is from a (ascii?)
    }

    // for loop is used for finding the max frequency
    for (int i = 0; i < 26; i++) {            
        if (frequency[i] != 0){
            if (frequency[i] > Max){
                Max = frequency[i];
            }
        }
    }

    //Loop is used for finding the most used letters in the message
    while (counter < 5){         
        for (int i = 0; i < 26; i++) {            
            if (frequency[i] == Max && counter < 5){
                Most_Used[counter] = i + 'a';
                ++counter;
            }
        }
        Max = Max - 1;
    }    

    // for loop used for checking the 5 the letters being compared
    for (int z = 0; z < 5; z++){
        shift = FREQ[z] - Most_Used[z];

        // for loop used for iterating through the message
        for(int y = 0; y < Length; y++){
            letter = arr[location][y];

            // checks if the letter is uppercase, converts to lowercase if so
            if (isupper(arr[location][y])){
                letter = letter +32;
            } 

            // checks if the char is a lowercase letter, does the shift if so
            if (letter >= 97 && letter <= 122){
                
                // checks if the ascii value of the letter would go out of range 
                if(!(letter+shift >= 97 && letter+shift <= 122) && shift > 0){
                   letter = letter - 26;
                }
                
                letter = letter + shift;                
                if (letter > 122){
                    letter = letter - 26;
                }

                else if (letter < 97){
                    letter = letter + 26;
		}                
            }            

            printf("%c", letter);
        }

        if (z != 4){
            printf("\nOR");
        }
        
        printf("\n");
    }

}

// function used to deallocate the memory used in the array
void Deallocate(char *arr[]){
    // for loop used for iterating through the array
    for (int z = 0; z < 10; z++){
        free(arr[z]);
    }
}
