section .bss
result              resd 1

current_x           resd 1
current_y           resd 1

width               resd 1
img_stride          resd 1
height              resd 1

imagesize           resd 1
headersize          resd 1

height_shape        resd 1
width_shape         resd 1
thickness_height    resd 1
thickness_width     resd 1

section .text
global find_markers

find_markers:
    ; Push frame pointer
    push    ebp

    ; Set frame pointer to current stack pointer
    mov     ebp, esp

    ; Load arguments from stack into registers
    mov     esi, [ebp + 8] ; file pointer

    ; Check if argument is pointer
    cmp     esi, 0
    je      error

    ; Read file type
    mov     eax, [esi]
    cmp     al, 66
    jne     error

    inc     esi
    mov     eax, [esi]
    cmp     al, 77
    jne     error

    ; Reset esi
    mov     esi, [ebp + 8] ; file pointer

    ; Go to header size
    add     esi, 14
    
    ; Read header size into ecx
    mov     ecx, 14
    add     ecx, [esi]
    mov     [headersize], ecx

    ; Go to width
    add     esi, 4
    mov     edx, [esi]
    mov     [width], edx
    imul     edx, 3
    mov     [img_stride], edx

    ; Go to height
    add     esi, 4
    mov     edx, [esi]
    mov     [height], edx

    ; Set edx to total size
    mov     edx, 0
    add     edx, [width]
    imul    edx, [height]

    ; Each pixel is 3 bytes
    imul    edx, 3
    
    ; Read image size into ecx
    add     ecx, edx
    ; Save size into imagesize
    mov     [imagesize], ecx

    ; Set shape counter
    mov     dword [result], 0

    ; Set starting x and y
    mov     dword [current_x], 0
    mov     dword [current_y], 0

; Check pixel of current_x and current_y
iterate_pixels:
    ; Get pixel at x and y from stack
    mov     eax, [current_x]
    mov     ecx, [current_y]

    ; Get pixel
    call    get_pixel

; Check if current RGB pixel is black
check_black_pixel:
    ; Check if pixel is black
    cmp     eax, 0
    jne     iterate_pixels_next

; Check if pixel on bottom, right and bottom right are non-black to prevent weird shapes
check_bottom_right:
    ; Check if bottom pixel is non-black
    mov     eax, [current_x]
    mov     ecx, [current_y]
    dec     ecx
    call    get_pixel

    ; Check if pixel is non-black
    cmp     eax, 0
    je      iterate_pixels_next

    ; Check if right pixel is non-black
    mov     eax, [current_x]
    inc     eax
    mov     ecx, [current_y]
    call    get_pixel

    ; Check if pixel is non-black
    cmp     eax, 0
    je      iterate_pixels_next

    ; Check if bottom right pixel is non-black
    mov     eax, [current_x]
    inc     eax
    mov     ecx, [current_y]
    dec     ecx
    call    get_pixel

    ; Check if pixel is non-black
    cmp     eax, 0
    je      iterate_pixels_next

; Initialise values for get_height_shape
start_get_height_shape:
    ; Set counter
    mov    dword [height_shape], 1

    ; Get height shape
    mov    eax, [current_x]
    mov    ecx, [current_y]
    add    ecx, [height_shape]

; Get the height of the found shape
get_height_shape:
    ; Get pixel
    call    get_pixel

    ; Check if pixel is black
    cmp     eax, 0
    jne     end_get_height_shape

    ; Check if out of bounds
    mov     ecx, [current_y]
    add     ecx, [height_shape]
    cmp     ecx, [height]
    jge     end_get_height_shape

    ; Increment counter
    inc     dword [height_shape]

    ; Get next pixel
    mov     eax, [current_x]
    mov     ecx, [current_y]
    add     ecx, [height_shape]
    jmp     get_height_shape

; Initialise values for get_width_shape
end_get_height_shape:
    ; Set counter
    mov    dword [width_shape], 1
    ; Get width shape
    mov    eax, [current_x]
    sub    eax, [width_shape]
    mov    ecx, [current_y]

; Get the width of the found shape
get_width_shape:
    ; Get pixel
    call    get_pixel

    ; Check if pixel is black
    cmp     eax, 0
    jne     end_get_width_shape

    ; Check if out of bounds
    mov     eax, [current_x]
    sub     eax, [width_shape]
    cmp     eax, 0
    jl      end_get_width_shape

    ; Increment counter
    inc     dword [width_shape]

    ; Get next pixel
    mov     eax, [current_x]
    sub     eax, [width_shape]
    mov     ecx, [current_y]
    jmp     get_width_shape

; Check if shape has twice the height of the width
end_get_width_shape:
    ; Check if height is 2 times bigger than width
    mov     ecx, [width_shape]
    imul    ecx, 2
    mov     eax, [height_shape]

    ; If not true go to next pixel
    cmp     eax, ecx
    jne     iterate_pixels_next

; Check if the top left pixel is non-black to prevent squares
check_top_left:
    ; Check if top left pixel of shape is non-black
    mov     eax, [current_x]
    sub     eax, [width_shape]
    inc     eax
    mov     ecx, [current_y]
    add     ecx, [height_shape]
    dec     ecx

    ; Get pixel
    call    get_pixel

    ; Check if pixel is non-black
    cmp     eax, 0
    je      iterate_pixels_next

; Save result by incrementing result and saving X and Y into array
save_result:
    ; Save X into array

    ; Load the address of the X array into eax
    mov     eax, [ebp + 12]  
    ; Load the value of X into ecx
    mov     ecx, [current_x]
    ; Store the value of X at the memory location pointed to by eax
    mov     [eax], ecx       
    ; Increment the pointer to the next memory address in the array
    add     eax, 4           
    ; Save the updated pointer back into the X array
    mov     [ebp + 12], eax  

    ; Save Y into array
    
    ; Load the address of the Y array into eax
    mov     eax, [ebp + 16]  
    ; Load the value of Y into ecx
    mov     ecx, [current_y]
    ; Store the value of Y at the memory location pointed to by eax
    mov     [eax], ecx       
    ; Increment the pointer to the next memory address in the array
    add     eax, 4           
    ; Save the updated pointer back into the Y array
    mov     [ebp + 16], eax  

    ; Increment counter
    inc     dword [result]

    ; Test if 50 or more markers are found, if true jump to end
    mov     eax, [result]
    cmp     eax, 50
    jge     end

    jmp     iterate_pixels_next

; Go to the next pixel by incrementing x, if x is out of bounds increment y
iterate_pixels_next:
    ; Increment x
    inc     dword [current_x]

    ; Check if x is out of bounds
    mov     eax, [current_x]
    mov     ecx, [current_y]

    cmp     eax, [width]
    jl      iterate_pixels

    ; Reset x
    mov     dword [current_x], 0

    ; Increment y
    inc     dword [current_y]

    ; Check if y is out of bounds
    cmp     ecx, [height]
    jl      iterate_pixels

    ; If X and Y are out of bounds, go to end
    jmp     end

; Get pixel at x and y
;   eax = x
;   ecx = y
; Return
;   eax = rgb
get_pixel:
    ; Check if out of bounds

    ; Check if X is lower than 0
    cmp     eax, 0
    jl      get_pixel_out_of_bounds

    ; Check if Y is lower than 0
    cmp     ecx, 0
    jl      get_pixel_out_of_bounds

    ; Check if X is greater or equal to width
    cmp     eax, [width]
    jge     get_pixel_out_of_bounds

    ; Check if Y is greater or equal to height
    cmp     ecx, [height]
    jge     get_pixel_out_of_bounds

    ; Get pointer to start of image
    mov     esi, [ebp + 8] ; file pointer

    ; Multiply x and y by 3 for 3 bytes per pixel
    imul    eax, 3

    ; Go to start of image
    add     esi, [headersize]

    ; Add X
    add     esi, eax
    ; Add Y * width
    imul    ecx, [img_stride]
    add     esi, ecx

    ; Get rgb data from next 3 bytes
    
    ; Clear the eax register
    xor     eax, eax 
    ; Clear the ecx register
    xor     ecx, ecx 
    ; Get the blue component
    mov     al, [esi + 0] 
    ; Get the green component
    mov     cl, [esi + 1] 
    ; Shift the green component to the left by 8 bits
    shl     ecx, 8 
    ; Combine the blue and green components
    or      eax, ecx 
    ; Get the red component
    mov     cl, [esi + 2] 
    ; Shift the red component to the left by 16 bits
    shl     ecx, 16 
    ; Combine the red component
    or      eax, ecx 

    ret
    
; Treat pixels out of bounds as white and return
get_pixel_out_of_bounds:
    mov     eax, 0xFFFFFFFF
    ret

; If an error occurs return -1
error:
    mov     eax, -1
    mov     [result], eax

end:
    ; Pop frame pointer
    pop     ebp

    ; Set result
    mov     eax, [result]

    ; Return
    ret
