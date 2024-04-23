section .bss
buffer resb 100
small_buffer resb 1

section .text
global firstdgtuppercase

firstdgtuppercase:
    ; Push frame pointer
    push ebp
    ; Set frame pointer to current stack pointer
    mov ebp, esp

    ; Push first argument to register
    mov esi, [ebp+8]
    mov edi, buffer

    mov ecx, 0
    mov edx, 0 ; Flag

    ; Loop through string
    loop:
        mov al, [esi]
        test al, al
        jz end_loop

        ; Check if flag is set
        cmp edx, 1
        je check_char

        ; Check if character is lower than 0
        cmp al, '0'
        jl next_char

        ; Check if character is higher than 9
        cmp al, '9'
        jg next_char

        ; Flag is not set if reached here and char is a digit
        jmp set_counter
        
    set_counter:
        ; Set counter to digit in char
        mov cl, al
        sub cl, '0'

        ; Set flag
        mov edx, 1

        jmp next_char

    check_char:
        ; Check if counter is higher than 0
        cmp cl, 0
        je next_char

        ; Lower counter
        dec cl

        ; Check if character is lower than a
        cmp al, 'a'
        jl next_char

        ; Check if character is higher than z
        cmp al, 'z'
        jg next_char

        ; Convert character to uppercase
        sub al, 32

    next_char:
        ; Add character
        mov [edi], al
        inc edi

        ; Go to next character
        inc esi
        jmp loop

    end_loop:
        mov byte [edi], 0

    end:
        mov eax, buffer

        ; Set stack pointer to frame pointer
        mov esp, ebp
        ; Pop frame pointer
        pop ebp
        ret