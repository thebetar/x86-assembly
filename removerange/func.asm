section .text
global removerange

; Removes all chars with ASCII values between a and b from string s
removerange:
    ; Push frame pointer
    push ebp
    ; Set frame pointer to current stack pointer
    mov ebp, esp
    
    ; Load arguments
    mov eax, [ebp + 8] ; s
    movzx ecx, byte [ebp + 12] ; a
    movzx edx, byte [ebp + 16] ; b

    ; Load address of new string
    push edi ; Save edi
    push esi ; Save esi
    mov edi, eax
    mov esi, eax

    ; Loop through string
    loop:
        ; Check if end of string
        cmp byte [esi], 0
        je end

        ; Check if char is in range
        cmp byte [esi], cl ; cl refers to the lower 8 bits of ecx
        jl notInRange
        cmp byte [esi], dl ; dl refers to the lower 8 bits of edx
        jg notInRange

        ; Move to next char if in range
        inc esi 
        jmp loop

    notInRange:
        ; Add char to new string
        mov al, [esi] ; Load char into lower 8 bits of eax
        mov [edi], al ; Store char in new string
        inc edi ; Move to next char in new string

        ; Move to next char
        inc esi
        jmp loop

    end:
        ; Null terminate new string
        mov byte [edi], 0

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
