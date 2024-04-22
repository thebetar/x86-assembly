section .bss
buffer resb 100

section .text
global reverseletters

reverseletters:
    ; Push frame pointer
    push ebp
    ; Set frame pointer to current stack pointer
    mov ebp, esp

    ; Push first argument to register
    mov esi, [ebp+8]
    ; Set edi to buffer
    mov edi, buffer

    ; Set ecx to reverse string
    mov ecx, esi

    ; Set ecx as pointer to last char
    get_last_char:
        ; Check if current char is null if so end
        cmp byte [ecx], 0
        je end_last_char

        inc ecx
        jmp get_last_char

    ; Decrement ecx to last char (not null terminator)
    end_last_char:
        dec ecx

    check_next_char:
        ; Check if current char is null if so end
        mov al, [esi]
        test al, al
        jz end_next_char

        ; If current char is lower than A in ascii go to next char
        cmp byte [esi], 0x41
        jl next_char

        ; If current char is higher than z in ascii go to next char
        cmp byte [esi], 0x7A
        jg next_char

        ; Check all chars between Z and a
        cmp byte [esi], 0x5B
        je next_char
        cmp byte [esi], 0x5C
        je next_char
        cmp byte [esi], 0x5D
        je next_char
        cmp byte [esi], 0x5E
        je next_char
        cmp byte [esi], 0x5F
        je next_char
        cmp byte [esi], 0x60
        je next_char

        ; If current char is a letter
        ; Save letter digit from ecx

    reverse_loop:
        ; Check if current char is null if so end
        cmp byte [ecx], 0
        je end_next_char

        ; If current char is lower than A in ascii go to next char
        cmp byte [ecx], 0x41
        jl reverse_loop_next_char

        ; If current char is higher than z in ascii go to next char
        cmp byte [ecx], 0x7A
        jg reverse_loop_next_char

        ; Check all chars between Z and a
        cmp byte [esi], 0x5B
        je reverse_loop_next_char
        cmp byte [esi], 0x5C
        je reverse_loop_next_char
        cmp byte [esi], 0x5D
        je reverse_loop_next_char
        cmp byte [esi], 0x5E
        je reverse_loop_next_char
        cmp byte [esi], 0x5F
        je reverse_loop_next_char
        cmp byte [esi], 0x60
        je reverse_loop_next_char

        ; If current char is a letter
        mov al, [ecx]
        mov [edi], al
        inc edi

        ; Decrement ecx for next time reverse_loop is called
        dec ecx

        ; Go to next char
        inc esi
        jmp check_next_char

    reverse_loop_next_char:
        dec ecx
        jmp reverse_loop

    next_char:
        ; Save non-digit char
        mov al, [esi]
        mov [edi], al
        inc edi

        ; Go to next char
        inc esi
        jmp check_next_char

    end_next_char:
        mov byte [edi], 0
    
    end:
        ; Set return value
        mov eax, buffer

        ; Set stack pointer to frame pointer
        mov esp, ebp
        ; Pop frame pointer
        pop ebp
        ret