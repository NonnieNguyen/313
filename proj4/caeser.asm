; Alan Nguyen CK38254, Peter Scrandis WO68214
	section .data

shift:		db	"Enter shift value: ", 0
len_n		equ	$-shift

request:	db	"Enter string location: ", 0
len_r		equ	$-request

current:	db	"Current message: ", 0
len_c		equ	$-current

encrypt:	db	"Encryption: ", 0
len_e		equ	$-encrypt

new_line	db	10

	section .bss
arr		resq	10
string_buff:	resb	8
string_len:	resb	8

num_buff:	resb	3
cipher_offset: 	resb	8	
min_phrase_len: resb	30

	section .text

	global 	start

start:
	mov	qword[string_buff], rdi

	xor	rcx, rcx
	call	getlen
	mov	qword[string_len], rcx

	call	gshift			;print and store the shift value

	xor 	rcx, rcx		;clear rcx

	mov 	r10, qword[min_phrase_len]	;store the length in r10

	mov 	rax, 1			;print prompt
	mov 	rdi, 1
	mov 	rsi, current
	mov 	rdx, len_c
	syscall

	mov	rax, 1			;print original message
	mov 	rdi, 1
	mov	rsi, qword[string_buff]
	mov	rdx, qword[string_len]
	syscall

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, new_line
	mov	rdx, 1
	syscall

	xor 	rcx, rcx ;clear rcx
	
	call	loop	;go to loop through the message and encrypt it

	mov 	rax, 1	;print prompt
	mov 	rdi, 1
	mov 	rsi, encrypt
	mov 	rdx, len_e
	syscall

	mov	rax, 1	;print encrypted message
	mov 	rdi, 1
	mov	rsi, qword[string_buff]
	mov	rdx, qword[string_len]
	syscall

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, new_line
	mov	rdx, 1
	syscall

	ret

getlen:
	mov	rdi, qword[string_buff]
	add	rdi, rcx
	cmp	byte[rdi], 0
	je	return
	inc 	rcx
	jmp	getlen

return:
	ret

gshift:

	;prints get shift message
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, shift
	mov	rdx, len_n
	syscall

	;storing shift
	mov	rax, 0
	mov	rdi, 0
	mov	rsi, num_buff
	mov	rdx, 3 ; double digit number + enter
	syscall

	cmp 	byte[num_buff + 1], 10 ;checks if the second byte is a newline char
	je 	working ;jumps to method for converting num_buff to numbers
	cmp 	byte[num_buff + 2], 10 ; checks if the third byte is a newline char
	jne 	clearstr; jumps to method for clearing the shift variable if its not a newline char

working:
	; converts num_buff to numbers
	; checking if correct value was input
	xor 	rax, rax
	sub 	byte[num_buff], 48 ;subtracting the first byte of num_buff = '1' by 48
	sub 	byte[num_buff + 1], 48 ;subtracting the second byte of numbuff = '2' by 48
	mov 	al, byte[num_buff] ;move the first byte of num_buff into the last byte of rax(al)
	cmp 	byte[num_buff + 1], 0
	jl 	skipbyte2

	mov 	rdx, 10 ;set rdx to 10
	mul 	rdx ;al = al * rdx
	xor 	rdx, rdx
	mov 	dl, byte[num_buff + 1] ;sets the last byte of rdx to the second byte of num_buff(2)
	add 	rax, rdx ;adds 2 to rax(10) to make it 12

skipbyte2:
	mov 	qword[cipher_offset], rax ;new 8 byte value is created to store the shift number

	xor 	rax, rax
	cmp	qword[cipher_offset], rax ;checks if the number is less than 0
	jl	gshift ;restarts and gets new number for shift
	mov 	rax, 25
	cmp 	qword[cipher_offset], rax ;checks if the number is greater than 25 
	jg	gshift ;restarts and gets new number for shift

	ret

clearstr:
	;goes through the num_buff until it is cleared (or hits \n)

	mov	rax, 0
	mov	rdi, 0
	mov	rsi, num_buff ; gets the leftover char, if number was greater than 2 digits
	mov	rdx, 1 ; double digit number + enter
	syscall
	
	cmp	byte[num_buff], 10 ;checks if the byte is a newline char
	jne 	clearstr ; if not newline char, loops back to the next char
	jmp 	gshift

loop: 
	; method used for checking if the char is uppercased or lowercased 
	mov	rdi, qword[string_buff]
	mov 	al, 'A'
	cmp	byte[rdi + rcx], al
	jl	incr 

	mov 	al, 'Z'
	cmp 	byte[rdi + rcx], al
	jle	upper 

	mov 	al, 'a'
	cmp	byte[rdi + rcx], al
	jl	incr

	mov 	al, 'z'
	cmp	byte[rdi + rcx], al
	jle	lower
	jmp 	incr 

incr:
	; used for iterating through the original sentence
	add	rcx, 1 ; moves which char the r8 is on, if r9 = 2, then r8 will be on the 3rd char, use for iterating through char spot
	cmp	rcx, qword[string_len]
	jl 	loop; loop for getting char spot
	ret

upper:
	; adds the shift to the ascii value, if value is greater than 90 goes to subalpha
	mov 	rax, qword[cipher_offset]
	add	byte[rdi + rcx], al
	mov 	al, 'Z'
	cmp	byte[rdi + rcx], al
	ja	subalpha
	jmp 	incr

lower:
	; add the shift to the ascii value, if value is greater than 122 goes to subalpha
	mov 	rax, qword[cipher_offset]
	add	byte[rdi + rcx], al
	mov 	al, 'z'
	cmp	byte[rdi + rcx], al
	ja 	subalpha
	jmp 	incr

subalpha:
	; subtracts 26 from the ascii value to loop back to the start of the alphabet
	mov 	al, 26
	sub	byte[rdi + rcx], al
	jmp 	incr
