;include 'caeser.asm'
extern read
extern display
extern decrypt

    section .data
menu:		db  "Encryption menu options", 10, "s - show curent messages", 10, "r - read new messages", 10, "c - caesar cypher", 10, "f - frequency decrypt", 10, "q - quit program", 10, "enter letter option -> ", 0
choice		equ $-menu

ogm:        db  "This is the original message."

new_line	db	10

    section .bss

arr resq 10
menu_buff:      resb    2
string_buff:	resb	1000000
num_buff:		resb	3

section .text

	global 	main

main:
    push rbp
	xor r8,r8

init:
	mov qword[arr+r8], ogm	;sets the first index to num
	add r8, 8				;increments the index
	cmp r8, 80				;increments until it reaches the end
	jl init

    xor r9, r9 ;position of what string to replace when reading
    jmp gmenu

gmenu:
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

menuaction:
    xor rcx, rcx
    cmp byte[menu_buff], 's'
    je  calldisplay
    cmp byte[menu_buff], 'S'
    je  calldisplay

    ;jumps to callread if user inputs r or R
    cmp byte[menu_buff], 'r'
    je  callread
    cmp byte[menu_buff], 'R'
    je  callread

    ;jumps to callread if user inputs r or R
    cmp byte[menu_buff], 'f'
    je  callfreq
    cmp byte[menu_buff], 'F'
    je  callread


    ;jumps to exit if user inputs q or Q
    cmp byte[menu_buff], 'q'
    je exit
    cmp byte[menu_buff], 'Q'
    je exit

    jmp gmenu

calldisplay:
    xor rdi, rdi
    mov rdi, arr
    call display
    jmp gmenu

callread:
    mov rdi, qword[arr + r9*8]
    mov rsi, r9
    call read
    jmp gmenu

callfreq:
    xor rdi, rdi
    mov rdi, arr
    call decrypt
    jmp gmenu
    
exit:
    ; prints a new line
	mov		rax, 1
	mov		rdi, 1
	mov		rsi, new_line
	mov		rdx, 1
	syscall

	mov 	rax, 60
	xor 	rdi, rdi
	syscall