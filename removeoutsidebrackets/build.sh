#! /bin/bash
# This script is used to build the executable from the assembly and C files.

mkdir -p dist

nasm -f elf32 func.asm -o dist/func.o
nasm -f elf32 lenfunc.asm -o dist/lenfunc.o
gcc -m32 -c main.c -o dist/main.o
gcc -m32 dist/func.o dist/lenfunc.o dist/main.o -o main
