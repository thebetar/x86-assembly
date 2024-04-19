section .text
global removenthchar

removenthchar:
    ; Push frame pointer
    push ebp
    ; Set frame pointer to current stack pointer
    mov ebp, esp

    ; Push first argument to register
    mov eax, [ebp+8]
    ; Push second argument to register
    mov ecx, [ebp+12]

    ; Set counter to 0
    mov edx, 1

    mov esi, eax
    mov edi, eax

    ; Loop through string
    loop:
        ; Check if we are at the end of the string
        cmp byte [esi], 0
        je end
        ; Check if we are at the nth character
        cmp edx, ecx
        je nthchar
        ; Write character to destination
        mov al, [esi]
        mov [edi], al
        ; Increment result pointer
        inc edi
        ; Increment source pointer
        inc esi
        ; Increment counter
        inc edx
        ; Loop
        jmp loop

    nthchar:
        ; Reset counter
        mov edx, 1
        ; Increment pointer
        inc esi
        ; Loop
        jmp loop

    end:
        ; Write null terminator
        mov byte [edi], 0

        ; Set the result in eax
        mov eax, [ebp + 8]

        ; Set stack pointer to frame pointer
        mov esp, ebp
        ; Pop frame pointer
        pop ebp

        ret