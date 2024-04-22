section .bss
buffer resb 100

section .text
global betweenasttoupper

betweenasttoupper:
    ; Push frame pointer
    push ebp
    ; Set frame pointer to current stack pointer
    mov ebp, esp

    ; Push first argument to register
    mov esi, [ebp+8]
    mov edi, buffer

    ; Get location of first asterisk and last
    first_loop:
        ; Check if char is null terminator
        cmp byte [esi], 0
        je end_first_loop

        ; Check if char is asterisk
        cmp byte [esi], 0x2A
        je set_asterisk

        ; Go to next char
        inc esi
        jmp first_loop

    set_asterisk:
        ; Set memory address stored in esi to eax (last asterisk)
        mov ecx, esi

        ; Check if first address of asterisk is already set
        cmp byte [eax], 0x2A
        je first_loop_next_char

        ; Set memory address stored in esi to eax (first asterisk)
        mov eax, esi

    first_loop_next_char:
        ; Go to next char
        inc esi
        jmp first_loop

    end_first_loop:
        ; Reset esi (edi was not modified yet)
        mov esi, [ebp+8]

    second_loop:
        ; Check if char is null terminator
        cmp byte [esi], 0
        je end_check

        ; If address is lower than first asterisk
        cmp esi, eax
        jl second_loop_next_char

        ; If address is higher than last asterisk
        cmp esi, ecx
        jg second_loop_next_char

        ; Check if char is lower than a
        cmp byte [esi], 0x61
        jl second_loop_next_char

        ; Check if char is higher than z
        cmp byte [esi], 0x7A
        jg second_loop_next_char

        ; If char is lowercase make uppercase and add to result
        sub byte [esi], 0x20
        
    second_loop_next_char:
        ; Save character to result
        mov dl, [esi]
        mov [edi], dl
        inc edi

        ; Go to next char
        inc esi
        jmp second_loop

    end_check:
        ; Add null terminator to result
        mov byte [edi], 0

    end:
        ; Set return value
        mov eax, buffer

        ; Set stack pointer to frame pointer
        mov esp, ebp
        ; Pop frame pointer
        pop ebp
        ret