#! /bin/bash
# This script is used to build the executable from the assembly and C files.

nasm -f elf32 func.asm -o dist/func.o
gcc -m32 -c main.c -o dist/main.o
gcc -m32 dist/func.o dist/main.o -o main
