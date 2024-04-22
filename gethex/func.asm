section .text
global gethex

gethex:
    ; Push frame pointer
    push ebp

    ; Set frame pointer to current stack pointer
    mov ebp, esp

    ; Push first argument to register
    mov eax, [ebp+8]

    ; Set esi and edi
    mov esi, eax
    mov edi, eax

    xor ecx, ecx

    check_char:
        cmp byte [esi], 0
        je end_check_char

        ; Check if char is 0
        cmp byte [esi], 0x30
        je set_first_flag

        ; Check if char is x
        cmp byte [esi], 0x78
        je set_second_flag

        ; ; Check if first flag is set
        cmp cl, 1
        jne reset_next_char

        ; ; Check if second flag is set
        cmp ch, 1
        jne reset_next_char

        ; Check if char is lower than 0
        cmp byte [esi], 0x30
        jl reset_next_char

        ; Check if char is higher than F
        cmp byte [esi], 0x46
        jg reset_next_char

        ; Check if char is between 0-9 and A-F in ASCII
        cmp byte [esi], 0x3A ; :
        je reset_next_char
        cmp byte [esi], 0x3B ; ;
        je reset_next_char
        cmp byte [esi], 0x3C ; <
        je reset_next_char
        cmp byte [esi], 0x3D ; =
        je reset_next_char
        cmp byte [esi], 0x3E ; >
        je reset_next_char
        cmp byte [esi], 0x3F ; ?
        je reset_next_char
        cmp byte [esi], 0x40 ; @
        je reset_next_char

        ; Save char
        mov al, [esi]
        mov [edi], al
        inc edi

        ; Go to next char
        inc esi
        jmp check_char

    set_first_flag:
        ; Check if flag is already set
        cmp cl, 1
        je set_zero_char

        ; Set first flag
        mov cl, 1

        ; Go to next char
        inc esi
        jmp check_char
    
    set_zero_char:
        ; Check if second flag is also set
        cmp ch, 1
        jne next_char

        ; Save char
        mov al, [esi]
        mov [edi], al
        inc edi

        ; Go to next char
        inc esi
        jmp check_char

    set_second_flag:
        ; Check if first flag is set
        cmp cl, 1
        jne reset_next_char

        ; Set second flag
        mov ch, 1

        ; Go to next char
        inc esi
        jmp check_char

    next_char:
        ; Go to next char
        inc esi
        jmp check_char

    reset_next_char:
        ; Reset flags
        mov cl, 0
        mov ch, 0

        ; Go to next char
        inc esi
        jmp check_char

    end_check_char:
        ; Set null terminator
        mov byte [edi], 0

    end:
        ; Set return value
        mov eax, [ebp+8]

        ; Set stack pointer to frame pointer
        mov esp, ebp
        ; Pop frame pointer
        pop ebp
    ret