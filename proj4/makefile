main: main.asm caeser.asm functions.c
	nasm -f elf64 -g main.asm
	nasm -f elf64 -g caeser.asm
	gcc -c -g functions.c
	gcc -m64 -g -o main main.o caeser.o functions.o

run: main
	./main

clean:
	rm *.o *.lst
