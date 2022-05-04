// Alan Nguyen CK38254, Peter Scrandis WO68214

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>

char FREQ[5] = {'e','t','a','o','i'};

// function for displatying all the arrays
void display(char *arr[]){ // s Or S
    // for loop iterates through the arrays and prints all the messages
    for (int z = 0; z < 10; z++){
        printf("Message[%d]: %s", z, arr[z]);

        // printf("Message[%d]: ", z); //prints Message[z] :
        // fputs(arr[z], stdout);      //prints Whatever is in index z in the array without printing an empty line
    }
}

// function used to add words to the arrays
// maybe change return type to help keep track of which message is being changed??
int read(char *arr[], int position){ //r or R
    printf(".");
    char word[1000];
    printf("Enter your message: ");
    scanf("%s",word);

    //gets(word);
    int Length = strlen(word);

    // if statments check if the first Letter is uppercase, and the char before newline is 
    if (isupper(word[0])){ 
        if (word[Length-1] == '!' || word[Length-1] == '.' || word[Length-1] == '?'){
            arr[position] = word;
            // if the message is added checks which message was changed and moves to the next one
            if (position == 9) position = 0; 
            else position++;
            printf("\n");
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
    int counter = 0, location, checker, Max = 0;
    int frequency[26] = {0};
    char Most_Used[5];

    
    //printf("Enter string location : ");
    //scanf("%d \n",location);

    
    // this is for testing to the function
    char Temp[] = {"This is an Original Message."};
    int Length = strlen(Temp);

    // for loop used for counting the frequency of letters in the message
    for (int z = 0; z < Length; z++){        
        frequency[ Temp[z] - 'a']++; // gets how far the letter is from a (ascii?)
    }

    // for loop is used for finding the max frequency
    for (int i = 0; i < 26; i++) {            
        if (frequency[i] != 0){
            if (frequency[i] > Max){
                Max = frequency[i];
            }
        }
    }

    //for loop used for for iterating through array to find most used letters
    while (counter < 5){         
        for (int i = 0; i < 26; i++) {            
            if (frequency[i] == Max && counter < 5){
                printf("%c : %d\n",i + 'a', frequency[i]); // gets the letter i letters away from a (ascii?)
                Most_Used[counter] = i + 'a';
                ++counter;
            }
        }
        Max = Max - 1;
    }    

    // temp
    // for loop prints outs the most used letters
    printf("Most common letters we are comparing to: ");
    for (int z = 0; z < 5; z++){
        printf("%c ",FREQ[z]);
    }

    printf("\nFrequency Shift starts after this \n");

    char letter;
    for (int z = 0; z < 5; z++){
        int shift = FREQ[z] - Most_Used[z];
        for(int y = 0; y < Length; y++){
           
            letter = Temp[y];
            if (isupper(Temp[y])){
                letter = letter +32;
            } 

            if (letter >= 97 && letter <= 122){
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
