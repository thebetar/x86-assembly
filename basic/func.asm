section .text
global add

add:
    ; Push frame pointer
    push ebp
    ; Set frame pointer to current stack pointer
    mov ebp, esp

    ; Push first argument to register
    mov eax, [ebp+8]
    ; Add the second argument to the first
    add eax, [ebp+12]
    
    ; Set stack pointer to frame pointer
    mov esp, ebp
    ; Pop frame pointer
    pop ebp
    ret