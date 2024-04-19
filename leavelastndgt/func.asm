section .text
global leavelastndgt

leavelastndgt:
    ; Push frame pointer
    push ebp
    ; Set frame pointer to current stack pointer
    mov ebp, esp

    ; Push first argument to register
    mov eax, [ebp+8]
    ; Add the second argument to the first
    mov ecx, [ebp+12]

    ; Set counter to store string length
    mov edx, 0
    ; Set source pointer to the start of the string
    mov esi, eax

    strlen:
        ; If the byte at the source pointer is null, jump to removechars
        cmp byte [esi], 0
        je remove_chars
        ; Increment counter
        inc edx
        ; Increment source pointer
        inc esi
        ; Next iteration
        jmp strlen

    remove_chars:
        ; Set source pointer to the start of the string
        mov esi, eax
        ; Set destination pointer to the start of the string
        mov edi, eax
        ; Subtract n from string length
        sub edx, ecx
        ; Move 0 into ecx
        mov ecx, 0  ; DONT USE ebx

    ; Remove all digits before the last n digits
    check_char:
        ; If the byte at the source pointer is null, jump to end
        cmp byte [esi], 0
        je end_copy
        ; If counter is more than the length of the string
        cmp ecx, edx
        jge copy_char
        ; Increment counter
        inc ecx
        ; Increment source pointer
        inc esi
        ; Next iteration
        jmp check_char

    copy_char:
        ; Copy the rest of the string
        mov al, [esi]
        mov [edi], al
        ; Increment destination pointer
        inc edi
        ; Increment source pointer
        inc esi
        ; Next iteration
        jmp check_char

    end_copy:
        ; Set null terminator
        mov byte [edi], 0

    end:
        ; Set result in eax
        mov eax, [ebp+8]

        ; Set stack pointer to frame pointer
        mov esp, ebp
        ; Pop frame pointer
        pop ebp

        ret