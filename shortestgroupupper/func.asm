section .bss
buffer resb 100
startAddress resb 4

section .text
global shortestgroupupper

shortestgroupupper:
    ; Push frame pointer
    push ebp
    ; Set frame pointer to current stack pointer
    mov ebp, esp

    ; Push first argument to register
    mov esi, [ebp+8]
    mov edi, buffer

    ; Set length counter
    mov ecx, 0
    ; Set shortest length
    mov edx, 100

    first_loop:
        ; Check if current char is null
        mov al, [esi]
        test al, al
        jz end_first_loop

        ; Check if current char is space
        cmp al, ' '
        je first_loop_next_char

        ; Increment length counter
        inc ecx

        ; Move to next char
        inc esi
        jmp first_loop

    first_loop_next_char:
        ; Check if len is 0
        cmp ecx, 0
        je first_loop

        ; Check if len is less than shortest len
        cmp ecx, edx
        jl first_loop_update_len

        ; Reset len
        mov ecx, 0

        ; Move to next char
        inc esi
        jmp first_loop

    first_loop_update_len:
        ; Update shortest len
        mov edx, ecx
        
        ; Save start address of shortest group
        sub esi, ecx
        sub esi, 1
        mov [startAddress], esi
        add esi, ecx
        add esi, 1

        ; Reset len
        mov ecx, 0

        ; Move to next char
        inc esi
        jmp first_loop

    end_first_loop:
        ; Reset esi to start of ebp+8
        mov esi, [ebp+8]

    second_loop:
        ; Check if current char is null
        mov al, [esi]
        test al, al
        jz end_second_loop

        ; Check if start address is null
        cmp byte [startAddress], 0
        jz second_loop_next_char

        ; Check if current address is greater than start address
        cmp esi, [startAddress]
        jg second_loop_save_char

        ; Move to next char
        jmp second_loop_next_char

    second_loop_save_char:

        ; Check if current char is space
        cmp al, ' '
        je reset_start_address

        ; Check if current char is lower than a
        cmp al, 'a'
        jl second_loop_next_char

        ; Check if current char is greater than z
        cmp al, 'z'
        jg second_loop_next_char

        ; Make character uppercase
        sub al, 32

        ; Save character to buffer
        mov [edi], al
        inc edi

        ; Move to next char
        inc esi
        jmp second_loop

    reset_start_address:
        ; Reset start address to null
        mov byte [startAddress], 0

    second_loop_next_char:
        ; Save character to buffer
        mov [edi], al
        inc edi

        ; Move to next char
        inc esi
        jmp second_loop

    end_second_loop:
        ; Set return value
        mov byte [edi], 0

    end:
        ; Return value
        mov eax, buffer

        ; Set stack pointer to frame pointer
        mov esp, ebp
        ; Pop frame pointer
        pop ebp
        ret