main: main.asm functions.c
	nasm -f elf64 -g main.asm
	gcc -c -g functions.c
	gcc -m64 -g -o main main.o functions.o

run: main
	./main

clean:
	rm *.o *.lst
