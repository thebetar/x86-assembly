section .bss
buffer resb 100

section .text
global removeoutsidebracketslen

removeoutsidebracketslen:
    ; Push frame pointer
    push ebp
    ; Set frame pointer to current stack pointer
    mov ebp, esp

    ; Push first argument to register
    mov esi, [ebp+8]

    ; Set edi to buffer
    mov edi, buffer

    ; Set flags
    mov ecx, 0
    mov edx, 0

    check_char:
        ; Check for null terminator
        mov al, [esi]
        test al, al
        jz end_check

        ; CHeck for [ if so set first flag
        cmp al, '['
        je set_first_flag

        ; Check for ] if so set second flag (with some conditions)
        cmp al, ']'
        je set_second_flag

        ; Check flags for character
        jmp check_flags

    set_first_flag:
        ; Set first flag
        mov ecx, 1
        
        jmp check_flags

    set_second_flag:
        ; Check if first flag is set
        cmp ecx, 1
        jne next_char

        ; Check if second flag is already set
        cmp edx, 1
        je next_char

        ; Set cur char so it does not get omitted after flag is set
        mov [edi], al
        inc edi

        ; Set second flag
        mov edx, 1

    check_flags:
        ; If first flag not set before first [
        cmp ecx, 0
        je next_char

        ; If second flag set after next ] after first [
        cmp edx, 1
        je next_char

    copy_char:
        ; Copy character to buffer
        mov [edi], al
        inc edi

    next_char:
        ; Go to next char
        inc esi
        jmp check_char

    end_check:
        ; Set null terminator
        mov byte [edi], 0
        mov esi, buffer

        ; Set counter to 0
        mov ecx, 0

    second_loop:
        ; Check for null terminator
        mov al, [esi]
        test al, al
        jz end

        inc ecx
        inc esi
        jmp second_loop

    end:
        ; Set return value
        mov eax, ecx

        ; Set stack pointer to frame pointer
        mov esp, ebp
        ; Pop frame pointer
        pop ebp
        ret