$(shell mkdir -p dist)

# main object file is made from main.c
# if there is an update in main.c run the command below
dist/main.o: main.c
	gcc -m32 -c main.c -o dist/main.o

# func object file is made from func.asm
# if there is an update in func.asm run the command below
dist/func.o: func.asm
	nasm -f elf32 func.asm -o dist/func.o

# main executable is made from main.o and func.o
# if there is an update in main.o or func.o run the command below
main: dist/main.o dist/func.o
	gcc -m32 dist/main.o dist/func.o -o main

# clean the object files and the executable
clean:
	rm -f dist/*.o main
