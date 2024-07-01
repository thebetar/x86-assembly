section .bss
result              resd 1

current_x           resd 1
current_y           resd 1

width               resd 1
img_stride          resd 1
height              resd 1

imagrsize           resd 1
headersize          resd 1

height_shape        resd 1
width_shape         resd 1
thickness_height    resd 1
thickness_width     resd 1

section .text
global find_markers

find_markers:
    ; Push frame pointer
    push    rbp

    ; Set frame pointer to current stack pointer
    mov     rbp, rsp

    ; Load arguments from stack into registers
    mov     rsi, [rbp + 8] ; file pointer

    ; Check if argument is pointer
    cmp     rsi, 0
    je      error

    ; Read file type
    mov     rax, [rsi]
    cmp     al, 66
    jne     error

    inc     rsi
    mov     rax, [rsi]
    cmp     al, 77
    jne     error

    ; Reset rsi
    mov     rsi, [rbp + 8] ; file pointer

    ; Go to header size
    add     rsi, 14
    
    ; Read header size into rcx
    mov     rcx, 14
    add     rcx, [rsi]
    mov     [headersize], rcx

    ; Go to width
    add     rsi, 4
    mov     rdx, [rsi]
    mov     [width], rdx
    imul     rdx, 3
    mov     [img_stride], rdx

    ; Go to height
    add     rsi, 4
    mov     rdx, [rsi]
    mov     [height], rdx

    ; Set rdx to total size
    mov     rdx, 0
    add     rdx, [width]
    imul    rdx, [height]

    ; Each pixel is 3 bytes
    imul    rdx, 3
    
    ; Read image size into rcx
    add     rcx, rdx
    ; Save size into imagrsize
    mov     [imagrsize], rcx

    ; Set shape counter
    mov     dword [result], 0

    ; Set starting x and y
    mov     dword [current_x], 0
    mov     dword [current_y], 0

; Check pixel of current_x and current_y
iterate_pixels:
    ; Get pixel at x and y from stack
    mov     rax, [current_x]
    mov     rcx, [current_y]

    ; Get pixel
    call    get_pixel

; Check if current RGB pixel is black
check_black_pixel:
    ; Check if pixel is black
    cmp     rax, 0
    jne     iterate_pixels_next

; Check if pixel on bottom, right and bottom right are non-black to prevent weird shapes
check_bottom_right:
    ; Check if bottom pixel is non-black
    mov     rax, [current_x]
    mov     rcx, [current_y]
    dec     rcx
    call    get_pixel

    ; Check if pixel is non-black
    cmp     rax, 0
    je      iterate_pixels_next

    ; Check if right pixel is non-black
    mov     rax, [current_x]
    inc     rax
    mov     rcx, [current_y]
    call    get_pixel

    ; Check if pixel is non-black
    cmp     rax, 0
    je      iterate_pixels_next

    ; Check if bottom right pixel is non-black
    mov     rax, [current_x]
    inc     rax
    mov     rcx, [current_y]
    dec     rcx
    call    get_pixel

    ; Check if pixel is non-black
    cmp     rax, 0
    je      iterate_pixels_next

; Initialise values for get_height_shape
start_get_height_shape:
    ; Set counter
    mov    dword [height_shape], 1

    ; Get height shape
    mov    rax, [current_x]
    mov    rcx, [current_y]
    add    rcx, [height_shape]

; Get the height of the found shape
get_height_shape:
    ; Get pixel
    call    get_pixel

    ; Check if pixel is black
    cmp     rax, 0
    jne     end_get_height_shape

    ; Check if out of bounds
    mov     rcx, [current_y]
    add     rcx, [height_shape]
    cmp     rcx, [height]
    jge     end_get_height_shape

    ; Increment counter
    inc     dword [height_shape]

    ; Get next pixel
    mov     rax, [current_x]
    mov     rcx, [current_y]
    add     rcx, [height_shape]
    jmp     get_height_shape

; Initialise values for get_width_shape
end_get_height_shape:
    ; Set counter
    mov    dword [width_shape], 1
    ; Get width shape
    mov    rax, [current_x]
    sub    rax, [width_shape]
    mov    rcx, [current_y]

; Get the width of the found shape
get_width_shape:
    ; Get pixel
    call    get_pixel

    ; Check if pixel is black
    cmp     rax, 0
    jne     end_get_width_shape

    ; Check if out of bounds
    mov     rax, [current_x]
    sub     rax, [width_shape]
    cmp     rax, 0
    jl      end_get_width_shape

    ; Increment counter
    inc     dword [width_shape]

    ; Get next pixel
    mov     rax, [current_x]
    sub     rax, [width_shape]
    mov     rcx, [current_y]
    jmp     get_width_shape

; Check if shape has twice the height of the width
end_get_width_shape:
    ; Check if height is 2 times bigger than width
    mov     rcx, [width_shape]
    imul    rcx, 2
    mov     rax, [height_shape]

    ; If not true go to next pixel
    cmp     rax, rcx
    jne     iterate_pixels_next

; Check if the top left pixel is non-black to prevent squares
check_top_left:
    ; Check if top left pixel of shape is non-black
    mov     rax, [current_x]
    sub     rax, [width_shape]
    inc     rax
    mov     rcx, [current_y]
    add     rcx, [height_shape]
    dec     rcx

    ; Get pixel
    call    get_pixel

    ; Check if pixel is non-black
    cmp     rax, 0
    je      iterate_pixels_next

; Save result by incrementing result and saving X and Y into array
save_result:
    ; Save X into array

    ; Load the address of the X array into rax
    mov     rax, [rbp + 12]  
    ; Load the value of X into rcx
    mov     rcx, [current_x]
    ; Store the value of X at the memory location pointed to by rax
    mov     [rax], rcx       
    ; Increment the pointer to the next memory address in the array
    add     rax, 4           
    ; Save the updated pointer back into the X array
    mov     [rbp + 12], rax  

    ; Save Y into array
    
    ; Load the address of the Y array into rax
    mov     rax, [rbp + 16]  
    ; Load the value of Y into rcx
    mov     rcx, [current_y]
    ; Store the value of Y at the memory location pointed to by rax
    mov     [rax], rcx       
    ; Increment the pointer to the next memory address in the array
    add     rax, 4           
    ; Save the updated pointer back into the Y array
    mov     [rbp + 16], rax  

    ; Increment counter
    inc     dword [result]

    ; Test if 50 or more markers are found, if true jump to end
    mov     rax, [result]
    cmp     rax, 50
    jge     end

    jmp     iterate_pixels_next

; Go to the next pixel by incrementing x, if x is out of bounds increment y
iterate_pixels_next:
    ; Increment x
    inc     dword [current_x]

    ; Check if x is out of bounds
    mov     rax, [current_x]
    mov     rcx, [current_y]

    cmp     rax, [width]
    jl      iterate_pixels

    ; Reset x
    mov     dword [current_x], 0

    ; Increment y
    inc     dword [current_y]

    ; Check if y is out of bounds
    cmp     rcx, [height]
    jl      iterate_pixels

    ; If X and Y are out of bounds, go to end
    jmp     end

; Get pixel at x and y
;   rax = x
;   rcx = y
; Return
;   rax = rgb
get_pixel:
    ; Check if out of bounds

    ; Check if X is lower than 0
    cmp     rax, 0
    jl      get_pixel_out_of_bounds

    ; Check if Y is lower than 0
    cmp     rcx, 0
    jl      get_pixel_out_of_bounds

    ; Check if X is greater or equal to width
    cmp     rax, [width]
    jge     get_pixel_out_of_bounds

    ; Check if Y is greater or equal to height
    cmp     rcx, [height]
    jge     get_pixel_out_of_bounds

    ; Get pointer to start of image
    mov     rsi, [rbp + 8] ; file pointer

    ; Multiply x and y by 3 for 3 bytes per pixel
    imul    rax, 3

    ; Go to start of image
    add     rsi, [headersize]

    ; Add X
    add     rsi, rax
    ; Add Y * width
    imul    rcx, [img_stride]
    add     rsi, rcx

    ; Get rgb data from next 3 bytes
    
    ; Clear the rax register
    xor     rax, rax 
    ; Clear the rcx register
    xor     rcx, rcx 
    ; Get the blue component
    mov     al, [rsi + 0] 
    ; Get the green component
    mov     cl, [rsi + 1] 
    ; Shift the green component to the left by 8 bits
    shl     rcx, 8 
    ; Combine the blue and green components
    or      rax, rcx 
    ; Get the red component
    mov     cl, [rsi + 2] 
    ; Shift the red component to the left by 16 bits
    shl     rcx, 16 
    ; Combine the red component
    or      rax, rcx 

    ret
    
; Treat pixels out of bounds as white and return
get_pixel_out_of_bounds:
    mov     rax, 0xFFFFFFFF
    ret

; If an error occurs return -1
error:
    mov     rax, -1
    mov     [result], rax

end:
    ; Pop frame pointer
    pop     rbp

    ; Set result
    mov     rax, [result]

    ; Return
    ret
