CC = gcc
ASM = nasm
CFLAGS = -g -m32
ASMFLAGS = -f elf32

all: main

main: main.o func.o
	$(CC) -m32 -o find_markers main.o func.o

main.o: main.c
	$(CC) $(CFLAGS) -c main.c

func.o: func.asm
	$(ASM) $(ASMFLAGS) func.asm -o func.o

clean:
	rm -f main.o func.o main

.PHONY: all clean
