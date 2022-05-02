include 'caeser.asm'
include 'functions.c'

    section .data
menu:		db  "Encryption menu options", 10, 
                "s - show curent messages", 10, 
                "r - read new messages", 10, 
                "c - caesar cypher", 10, 
                "f - frequency decrypt", 10, 
                "q - quit program", 10,
                "enter letter option -> ", 0
choice		equ $-start6

    section .bss
arr             resq    10
menu_buff:      resb    2
string_buff:	resb	1000000
num_buff:		resb	3

section .text

	global 	main

main:
    mov r9, 0 ;position of what string to replace when reading
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
    ;jumps to callread if user inputs r or R
    cmp byte[menu_buff], 'r'
    je  callread
    cmp byte[menu_buff], 'R'
    je  callread

    ;jumps to exit if user inputs q or Q
    cmp byte[menu_buff], 'q'
    je exit
    cmp byte[menu_buff], 'Q'
    je exit

    jmp gmenu

callread:
    mov rdi, arr
    mov rsi, r9
    call read
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