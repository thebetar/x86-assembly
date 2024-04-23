; Reserve space for buffer
section .bss
buffer resb 100

; Define variables to 0
section .data
counter db 0
maxcounter db 0
maxchar db 0

section .text
global mostfrequentupper

mostfrequentupper:
    ; Push frame pointer
    push ebp
    ; Set frame pointer to current stack pointer
    mov ebp, esp

    ; Push first argument to register
    mov esi, [ebp+8]
    mov edi, buffer

    mov ecx, [ebp+8]

    ; Loop through string
    outer_loop:
        ; Check if character is null terminator
        mov al, [esi]
        test al, al
        jz end_outer_loop

        ; Reset inner pointer
        mov ecx, [ebp+8]

        ; Reset counter
        mov byte [counter], 0

        inner_loop:
            ; Check if character is null terminator
            mov dl, [ecx]
            test dl, dl
            jz end_inner_loop


            ; Check if character is same as checked character
            cmp al, dl
            je inner_loop_increment

            ; Go to next char
            inc ecx
            jmp inner_loop

        inner_loop_increment:
            ; Increment current character counter
            inc byte [counter]

            ; Go to next char
            inc ecx
            jmp inner_loop

        end_inner_loop:
            mov cl, byte [counter]
            mov dl, byte [maxcounter]

            ; Check if current counter is higher than max counter
            cmp cl, dl
            jl outer_loop_next_char

            ; Set max counter to current counter pointed to by maxcounter
            mov byte [maxcounter], cl

            ; Set max char to current char
            mov byte [maxchar], al

            ; Go to next char in outer loop
            jmp outer_loop_next_char
        
        outer_loop_next_char:
            inc esi
            jmp outer_loop

    end_outer_loop:
        mov esi, [ebp+8]

        ; Set max character byte into cl
        mov cl, [maxchar]

    second_loop:
        ; Check if character is null terminator and set contents of esi to al
        mov al, [esi]
        test al, al
        jz end

        ; Check if current char is same as max char
        cmp al, cl
        jne next_char

        ; Check if character is lower than a
        cmp al, 'a'
        jl next_char

        ; Check if character is higher than z
        cmp al, 'z'
        jg next_char

        ; Convert character to upper case if same as max char and lowercase
        sub al, 32

    next_char:
        mov [edi], al
        inc edi

        inc esi
        jmp second_loop

    end:
        ; Add null terminator
        mov byte [edi], 0

        ; Return value
        mov eax, buffer

        ; Set stack pointer to frame pointer
        mov esp, ebp
        ; Pop frame pointer
        pop ebp
        ret