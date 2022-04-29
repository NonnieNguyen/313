include 'caeser.asm'
include 'functions.c'

    section .data
start1:		db "Encryption menu options",10
start2:		db "s - show curent messages",10
start3:		db "r - read new messages",10
start4:		db "c - caesar cypher",10
start5:		db "f - frequency decrypt",10
start6:		db "q - quit program",10
choice		equ $-start6

    section .bss
string_buff:	resb	1000000
num_buff:		resb	3

section .text

	global 	main