main: main.asm functions.c
	nasm -f elf64 main.asm
	gcc -c functions.c
	gcc -m64 -o main main.o functions.o

run: main
	./main

clean:
	rm *.o *.lst
