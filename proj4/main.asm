extern read
extern display
extern malloc
extern realloc
extern free
extern decrypt
extern start

%define ARR_LEN 10
%define ARR_SIZE 80 ;in bytes

    section .data
menu:		db  "Encryption menu options", 10, "s - show curent messages", 10, "r - read new messages", 10, "c - caesar cypher", 10, "f - frequency decrypt", 10, "q - quit program", 10, "enter letter option -> ", 0
choice		equ $-menu

request:	db	"Enter string location: ", 0
len_r		equ	$-request

invalid:    db  "invalid option, try again"
wrong       equ $-invalid

string1:    db  "This is the original message.", 0
stringLen:  equ $-string1

new_line	db	10

    section .bss

arr resq ARR_LEN

location_buff:	resb	3
index:	resb	8

menu_buff:      resb    2
string_buff:	resb	1000000
num_buff:		resb	3
replace_index:  resd    8

section .text

	global 	main

main:
    push rbp
	xor r8,r8
    
init:
    ; allocate memory for new array, store value of r8 on stack
    push r8
    sub rsp, 8  ; align stack pointer
    mov rdi, stringLen
    call malloc
    add rsp, 8  ; un-do stack operations
    pop r8
	mov qword[arr+r8], rax	;sets the first index to the allocated pointer
    ; make a deep copy of the string
    xor r9, r9
strDeepCopyLoop:
    mov bl, byte[string1 + r9]
    mov byte[rax + r9], bl
    inc r9
    cmp r9, stringLen
    jl strDeepCopyLoop
    
	add r8, 8				;increments the index
	cmp r8, ARR_SIZE    	;increments until it reaches the end
	jl init


    mov qword[replace_index], 0     ;position of what string to replace when reading
    jmp gmenu

gmenu:
    mov rax, 1
	mov rdi, 1
	mov rsi, new_line
	mov rdx, 1
	syscall
    ;prints the menu
    mov rax, 1
    mov rdi, 1
    mov rsi, menu
    mov rdx, choice
    syscall

    ;stores the user input in menu_buff
    mov rax, 0
    mov rdi, 0
    mov rsi, menu_buff
    mov rdx, 2
    syscall ;be sure to check for more than 1 character, should en in \n

    cmp byte[menu_buff + 1], 10
    jne toclear

menuaction:
    ;xor rcx, rcx
    cmp byte[menu_buff], 's'
    je  calldisplay
    cmp byte[menu_buff], 'S'
    je  calldisplay

    ;jumps to callread if user inputs r or R
    cmp byte[menu_buff], 'r'
    je  callread
    cmp byte[menu_buff], 'R'
    je  callread

    cmp byte[menu_buff], 'c'
    je  gstring
    cmp byte[menu_buff], 'C'
    je  gstring

    cmp byte[menu_buff], 'f'
    je  calldecrypt
    cmp byte[menu_buff], 'F'
    je  calldecrypt

    ;jumps to exit if user inputs q or Q
    cmp byte[menu_buff], 'q'
    je exit
    cmp byte[menu_buff], 'Q'
    je exit

    ;jmp gmenu
    cmp byte[menu_buff + 1], 10
    je  gmenu

toclear:
    mov rax, 1
    mov rdi, 1
    mov rsi, invalid
    mov rdx, wrong
    syscall

    mov rax, 1
	mov rdi, 1
	mov rsi, new_line
	mov rdx, 1
	syscall

clearing:
    mov rax, 0
	mov rdi, 0
	mov rsi, menu_buff ; gets the leftover char, if number was greater than 2 digits
	mov rdx, 1 ; double digit number + enter
	syscall

	cmp byte[menu_buff], 10 ;checks if the byte is a newline char
	jne clearing ; if not newline char, loops back to the next char
	jmp gmenu

calldisplay:
    xor rdi, rdi
    mov rdi, arr
    call display
    jmp gmenu

callread:
    mov rdi, arr
    xor rsi, rsi
    mov rsi, qword[replace_index]
    call read
    mov qword[replace_index], rax
    cmp qword[replace_index], ARR_LEN
    jae modTen
    jmp gmenu

gstring:
	mov		rax, 1	;prints the request for the original string
	mov		rdi, 1
	mov		rsi, request
	mov		rdx, len_r
	syscall

	mov		rax, 0	;stores the original string
	mov		rdi, 0
	mov		rsi, location_buff
	mov		rdx, 3
	syscall
    
    mov rax, 1
    mov rdi, 1
    mov rsi, arr[1]
    mov rdx, 38

	cmp	byte[location_buff + 1], 10 ;checks if the second byte is a newline char
	je	tofix ;jumps to method for converting num_buff to numbers
	cmp	byte[location_buff + 2], 10 ; checks if the third byte is a newline char
	jne	toclear; jumps to method for clearing the shift variable if its not a newline char

tofix:
	; converts num_buff to numbers
	; checking if correct value was input
	xor 	rax, rax
	sub 	byte[location_buff], 48 ;subtracting the first byte of num_buff = '1' by 48
	sub 	byte[location_buff + 1], 48 ;subtracting the second byte of numbuff = '2' by 48
	mov 	al, byte[location_buff] ;move the first byte of num_buff into the last byte of rax(al)
	cmp 	byte[location_buff + 1], 0
	jl 		storeindex

	mov 	rdx, 10 ;set rdx to 10
	mul 	rdx ;al = al * rdx
	xor 	rdx, rdx
	mov 	dl, byte[location_buff + 1] ;sets the last byte of rdx to the second byte of num_buff(2)
	add 	rax, rdx ;adds 2 to rax(10) to make it 12

storeindex:
	mov	qword[index], rax

	mov rax, 1
	cmp qword[index], rax
	jl 	gstring

	mov rax, 10
	cmp qword[index], rax
	jg	gstring

	mov	rax, 8
	mul	qword[index]
	sub	rax, 8
	mov	qword[index], rax

callceaser:
    xor rdi, rdi
    mov rcx, qword[index]
    mov rdi, qword[arr + rcx]
    call start
    jmp gmenu

calldecrypt:
    xor rdi, rdi
    mov rdi, arr
    call decrypt
    jmp gmenu

modTen:
    sub qword[replace_index], ARR_LEN
    jmp gmenu

exit:
    ; free the dynamically allocated memory
    xor rcx, rcx
freeLoop:
    push rcx
    sub rsp, 8  ; align stack pointer
    mov rdi, qword[arr + 8*rcx]     ; move dynamically-allocated string into rdi
    call free
    add rsp, 8  ; un-do stack operations
    pop rcx
    inc rcx             ; for loop type thing, free all memory
    cmp rcx, ARR_LEN
    jl freeLoop
    ; prints a new line
	mov rax, 1
	mov rdi, 1
	mov rsi, new_line
	mov rdx, 1
	syscall

	mov rax, 60
	xor rdi, rdi
	syscall