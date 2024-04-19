# Introduction

Sometimes C does not give enough control so a function written in assembly is needed.
To achieve this create a C file (.c) and an assembly file (.asm). (To see a basic example look in this directory).
Secondly build both these program to object files that can be linked using

1. Create the object file from the assembly file

    ```bash
    nasm -f elf32 "ASSEMBLY_FILE.asm" -o "OUTPUT_OBJECT_1.o"
    ```

    This command calls the `nasm` binary with the specific format to create a 32-bit executable and linkable file using the `-f elf32` option.
    Finally the output type of an object file is denoted as an object file using `.o`.

2. To create the object file from the assembly program and

    ```bash
    gcc -m32 -c "C_FILE.c" -o "OUTPUT_OBJECT_2.o"
    ```

    This command calls the `gcc` binary with the specific format to create a 32-bit executable and linkable file using the `-m32` option.
    Finally the output type of an object file is denoted as an object file using `.o`.

3. Finally to link these two program together use the GNU C compiler with the command
    ```bash
    gcc -m32 "OUTPUT_OBJECT_1.o" "OUTPUT_OBJECT_2.o" -o "OUTPUT_EXECUTABLE"
    ```
    This command calls the `gcc` binary to link the two object files. To let the compiler know the files are 32-bit executables the `-m32` option is passed again.
    Finally the output type of an exectuable is denoted by not giving one.

And that's it an executable has been created that uses the function defined in the assembly file.

Important notes:

-   Using `ebx` register is not advisable try to avoid it
-   The `C` programming language has some types which are read only like char pointers this can be avoided by using `char str[]` instead of `char * str` when testing. This issue does not seem to appear if the string is taken from input.
