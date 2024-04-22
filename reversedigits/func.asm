section .data
buffer db 100

section .text
global reversedigits

reversedigits:
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
        cmp byte [esi], 0
        je end_next_char

        ; If current char is lower than 0 in ascii go to next char
        cmp byte [esi], 0x30
        jl next_char

        ; If current char is higher than 9 in ascii go to next char
        cmp byte [esi], 0x39
        jg next_char

        ; If current char is a digit
        ; Save last digit from ecx

    reverse_loop:
        ; Check if current char is null if so end
        cmp byte [ecx], 0
        je end_next_char

        ; If current char is lower than 0 in ascii go to next char
        cmp byte [ecx], 0x30
        jl reverse_loop_next_char

        ; If current char is higher than 9 in ascii go to next char
        cmp byte [ecx], 0x39
        jg reverse_loop_next_char

        ; If current char is a digit
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