extern read
extern display
extern malloc
extern realloc
extern free
extern decrypt
extern start
extern deallocate

%define ARR_LEN 10
%define ARR_SIZE 80 ;in bytes

	section .data
menu:		db  	"Encryption menu options", 10, "s - show curent messages", 10, "r - read new messages", 10, "c - caesar cypher", 10, "f - frequency decrypt", 10, "q - quit program", 10, "enter letter option -> ", 0
	
choice		equ 	$-menu

request:	db	"Enter string location: ", 0
len_r		equ	$-request

invalid:    	db  	"invalid option, try again"
wrong       	equ 	$-invalid

string1:    	db  	"This is the original message.", 0
stringLen:  	equ 	$-string1

egg_msg:    	db  	"EASTER EGG! POGCHAMP", 0
len_e   	equ 	$-egg_msg

new_line	db	10

	section .bss

arr: 		resq 	ARR_LEN

location_buff:	resb	2
index:		resb	8

menu_buff:      resb    2
string_buff:	resb	1000000
num_buff:	resb	3
replace_index:  resb    8

z_count: 	resb 	8

section .text

	global 	main

main:
	push 	rbp
	xor 	r8,r8
    
init:
	;allocate memory for new array, store value of r8 on stack
	push 	r8
	sub 	rsp, 8  		;align stack pointer
	mov 	rdi, stringLen
	call 	malloc			;allocate space to hold a deep copy of the og string
	add 	rsp, 8  		;un-do stack pointer
	pop 	r8
	mov 	qword[arr+r8], rax	;sets the first index to the allocated pointer
	
	xor 	r9, r9
strDeepCopyLoop:
	mov 	bl, byte[string1 + r9] 
	mov 	byte[rax + r9], bl
	inc 	r9
	cmp 	r9, stringLen
	jl 	strDeepCopyLoop
    
	add 	r8, 8			;increments the index
	cmp 	r8, ARR_SIZE    	;increments until it reaches the end
	jl 	init

	mov 	qword[replace_index], 0 ;position of what string to replace when reading
	jmp 	gmenu

gmenu:
	mov 	rax, 1
	mov 	rdi, 1
	mov 	rsi, new_line		;prints the menu
	mov 	rdx, 1
	syscall

	mov 	rax, 1
	mov 	rdi, 1
	mov 	rsi, menu		;asks for user input command
	mov 	rdx, choice
	syscall

	mov 	rax, 0
	mov 	rdi, 0
	mov 	rsi, menu_buff		;stores the user input in num buff
	mov 	rdx, 2
	syscall

	cmp 	byte[menu_buff + 1], 10	;if there is more than one character in menu_buff then it clears the remaining inputs
	jne 	toclear

menuaction:
	cmp 	byte[menu_buff], 'z' 	;if the input is z then jumps to incz
	je  	incz
	cmp 	byte[menu_buff], 'Z'
	je  	incz

	mov 	byte[z_count], 0 	;resets the number of times z was incremented

	cmp 	byte[menu_buff], 's' 	;if the input was s then it jumps to calldisplay
	je  	calldisplay
	cmp 	byte[menu_buff], 'S'
	je  	calldisplay
					
	cmp 	byte[menu_buff], 'r' 	;if the input was r then it jumps to callread
	je  	callread
	cmp 	byte[menu_buff], 'R'
	je  	callread

	cmp 	byte[menu_buff], 'c' 	;if the input was c then it jumps to gstring
	je  	gstring
	cmp 	byte[menu_buff], 'C'
	je  	gstring

	cmp 	byte[menu_buff], 'f' 	;if the input was f then it jumps to calldecrypt
	je  	calldecrypt
	cmp 	byte[menu_buff], 'F'
	je  	calldecrypt

	cmp 	byte[menu_buff], 'q' 	;if the input was q then it jumps to exit
	je 	exit
	cmp 	byte[menu_buff], 'Q'
	je 	exit

toclear:
	mov 	rax, 1
	mov 	rdi, 1
	mov 	rsi, invalid		;tells the user that their input was invalid
	mov 	rdx, wrong
	syscall

	mov 	rax, 1
	mov 	rdi, 1
	mov 	rsi, new_line		;prints a new line
	mov 	rdx, 1
	syscall

	cmp 	byte[menu_buff + 1], 10 ;checks if the byte is a newline char
	jne 	clearing 		;if not newline char, loops back to the next char
	jmp 	gmenu

clearing:
	mov 	rax, 0
	mov 	rdi, 0
	mov 	rsi, menu_buff 		;gets the leftover char, if input was greater than 1 character
	mov 	rdx, 1
	syscall

	cmp 	byte[menu_buff], 10 	;checks if the byte is a newline char
	jne 	clearing 		;if not newline char, loops back to the next char
	jmp 	gmenu

calldisplay:
	xor 	rdi, rdi		;clears rdi
	mov 	rdi, arr		;stores arr in rdi as the first parameter in the c function
	call 	display			;calls the display c function
	jmp 	gmenu			;jumps back to gmenu for the next input

callread:
	xor	rdi, rdi		;clears rdi
	mov 	rdi, arr		;stores arr in rdi as the first parameter
	xor 	rsi, rsi		;clears rsi and stores the index where to replace the string
	mov 	rsi, qword[replace_index]
	call 	read			;calls the read c function and stores the returned index in replace_index
	mov 	qword[replace_index], rax
	cmp 	qword[replace_index], ARR_LEN
	jae 	modTen			;%10 the replace_index if it is greater than the length of the array
	jmp 	gmenu

gstring:
	mov	rax, 1			;prints the request for the original string
	mov	rdi, 1
	mov	rsi, request
	mov	rdx, len_r
	syscall

	mov	rax, 0			;stores the original string
	mov	rdi, 0
	mov	rsi, location_buff
	mov	rdx, 2
	syscall

	cmp 	byte[location_buff + 1], 10
	jne 	toclear			;tells the user that their input is invalid if they input a location more than 1 character

tofix:
	sub 	byte[location_buff], 48
	xor 	rax, rax
	cmp 	byte[location_buff], al
	jl  	gstring			;asks for a new location if the input is less than ASCII 0

	xor	rax, rax
	mov 	al, 9
	cmp 	byte[location_buff], al
	jg  	gstring			;asks for a new location if the input is greater than ASCII 9

storeindex:
	mov 	al, byte[location_buff]
	mov	qword[index], rax 	;stores the users desired index in index

	mov	rax, 8
	mul	qword[index]		;multiplies the index by 8 to get the proper index in assembly since it's dog
	mov	qword[index], rax	;stores the index in index

callceaser:
	xor 	rdi, rdi		;clears rdi
	mov 	rcx, qword[index]	;stores the index in rcx
	mov 	rdi, qword[arr + rcx]	;moves the array at index rcx into rdi
	call 	start			;calls the start assembly lable in caeser.asm
	jmp 	gmenu			;jumps to menu for new input

calldecrypt:
	xor 	rdi, rdi		;clears rdi
	mov 	rdi, arr		;moves the array into rdi
	call 	decrypt			;calls the decrypt c function
	jmp 	gmenu			;jumps to menu for new input

modTen:
	sub 	qword[replace_index], ARR_LEN
	jmp 	gmenu			;subtracts the replace index for read by 10 if the replace index is greater than 10

incz:
	inc 	qword[z_count]		;increments z_count by 1
	cmp 	qword[z_count], 4	;if z_count is 1 then jumps to egg lable
	je  	egg
	jmp 	toclear

egg:
	mov 	qword[z_count], 0 	;resets the z_count

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, egg_msg		;prints the easter egg message
	mov	rdx, len_e
	syscall

	jmp 	gmenu			;jumps back to gmenu

exit:
					;free the dynamically allocated memory before exiting
	xor 	rdi, rdi		;clears rdi
	mov 	rdi, arr		;moves the array into rdi
	call 	deallocate		;calls the deallocate c function
	mov 	rax, 60			;exits
	xor 	rdi, rdi
	syscall
	
