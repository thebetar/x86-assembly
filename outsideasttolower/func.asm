section .bss
buffer resb 100

section .text
global outsideastlower

outsideastlower:
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
        cmp byte [eax], '*'
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
        jl second_loop_to_lower

        ; If address is higher than last asterisk
        cmp esi, ecx
        jg second_loop_to_lower
        
    second_loop_next_char:
        ; Save character to result
        mov dl, [esi]
        mov [edi], dl
        inc edi

        ; Go to next char
        inc esi
        jmp second_loop

    second_loop_to_lower:
        ; Check if char is lower than A
        cmp byte [esi], 'A'
        jl second_loop_next_char

        ; Check if char is higher than Z
        cmp byte [esi], 'Z'
        jg second_loop_next_char

        ; If char is uppercase, convert to lowercase
        add byte [esi], 32

        jmp second_loop_next_char

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