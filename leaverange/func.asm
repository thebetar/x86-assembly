section .text
global leaverange

; Removes all chars with ASCII values between a and b from string s
leaverange:
    ; Push frame pointer
    push ebp
    ; Set frame pointer to current stack pointer
    mov ebp, esp
    
    ; Load arguments
    mov eax, [ebp + 8] ; s
    movzx ecx, byte [ebp + 12] ; a
    movzx edx, byte [ebp + 16] ; b

    ; Load address of new string
    push esi ; Save esi
    push edi ; Save edi

    ; Set edi and esi to start of string
    mov esi, eax
    mov edi, eax

    ; Loop through string
    check_char:
        ; Check if end of string
        cmp byte [esi], 0
        je end_check_char

        ; Check if char is in range
        cmp byte [esi], cl ; cl refers to the lower 8 bits of ecx
        jl next_char
        cmp byte [esi], dl ; dl refers to the lower 8 bits of edx
        jg next_char

        ; Add char to new string
        mov al, [esi] ; Load char into lower 8 bits of eax
        mov [edi], al ; Store char in new string
        inc edi ; Move to next char in new string

    next_char:
        ; Move to next char
        inc esi
        jmp check_char

    end_check_char:
        ; Null terminate new string
        mov byte [edi], 0

    end:
        ; Restore edi and esi
        pop esi
        pop edi

        ; Set the result in eax
        mov eax, [ebp + 8]
        
        ; Set stack pointer to frame pointer
        mov esp, ebp
        ; Pop frame pointer
        pop ebp

        ret
