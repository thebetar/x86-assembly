section .text
global removerep

; Function to remove repeated characters from a string
removerep:
    ; Push frame pointer
    push ebp
    ; Set frame pointer to current stack pointer
    mov ebp, esp

    ; Push argument to register
    mov esi, [ebp+8]
    ; Push empty space to register
    mov edi, [ebp+8]

    ; Set up last character register
    xor ecx, ecx

    ; Loop over every ascii char and check if it is repeated
    check_char:
        cmp byte [esi], 0
        je end_check_char

        mov al, [esi]

        ; Check if character is same as last
        cmp al, cl
        je skip_char

        ; If not same, set destination and update last char
        mov [edi], al
        mov cl, al
        inc edi

    ; Increment pointer and check next character
    skip_char:
        ; Increment pointer
        inc esi
        jmp check_char

    ; End of string
    end_check_char:
        ; Add null terminator
        mov byte [edi], 0

    end:
        ; Set result register
        mov eax, [ebp+8]

        ; Set stack pointer to frame pointer
        mov esp, ebp
        ; Pop frame pointer
        pop ebp
        ret