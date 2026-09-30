bits 32

VIDEO_MEMORY equ 0xb8000

SCREEN_WIDTH equ 80
SCREEN_HEIGHT equ 25

VGA_INDEX_PORT equ 0x3d4
VGA_DATA_PORT equ VGA_INDEX_PORT + 1

global clear_screen
global set_cursor_pos
global print_str
global print_char
global new_line

section .text

; screen 80 x 25 chars
;clear_screen:
;    push eax
;    push ebx
;
;    mov eax, 0
;    mov ax, 0x0f00 | ' '        ; space with black and white
;    mov ebx, VIDEO_MEMORY
;clear_screen_loop:
;    mov [ebx], ax
;    add ebx, 2
;    cmp ebx, VIDEO_MEMORY + SCREEN_WIDTH * SCREEN_HEIGHT * 2
;    jne clear_screen_loop
;clear_screen_end:
;    xor ax, ax
;    mov bx, ax
;    call set_cursor_pos
;
;    pop ebx
;    pop eax
;    ret

update_cursor_pos:
    push bx
    push ax

    mov bx, [cursor_position_x]
    mov ax, [cursor_position_y]

    call set_cursor_pos

    pop ax
    pop bx
    ret

; bx - cursor pos x
; ax - cursor pos y
set_cursor_pos:
    push dx

    ; store the position
    mov [cursor_position_x], bx
    mov [cursor_position_y], ax

    ; calculating coordinates of the cursor
    mov dl, SCREEN_WIDTH
    mul dl
    add bx, ax

    ; move the cursor
    mov dx, VGA_INDEX_PORT
    mov al, 0x0f            ; tell we want to send the low byte
    out dx, al

    inc dl
    mov al, bl
    out dx, al              ; send low byte

    dec dl
    mov al, 0x0e            ; tell we want to send the high byte
    out dx, al

    inc dl
    mov al, bh
    out dx, al              ; send the high byte

    pop dx
    ret

; eax - char *
; bh - char color << 8 bits
;print_str:
;    push ecx
;
;    mov ecx, eax
;    mov ax, bx
;print_loop:
;    mov ax, bx
;    mov al, [ecx]
;    cmp al, 0
;    jz print_end
;
;    call print_char
;
;    inc ecx
;    jmp print_loop
;print_end:
;    pop ecx
;    ret

; ax - char to put on screen at cursor pos
;print_char:
;    ; preserve registers that are in use by subroutine
;   push edx
;    push ecx
;    push ebx
;
;    mov cx, ax
;    mov eax, [cursor_position_x]
;    mov ebx, [cursor_position_y]
;    imul ebx, SCREEN_WIDTH * 2                ; cursor_position_x *= 80
;    imul eax, 2
;    add eax, ebx                    ; eax += ebx
;    mov edx, VIDEO_MEMORY
;    add edx, eax                    ; edx - address of the current char
;    mov [edx], cx
;
;    mov eax, [cursor_position_x]
;    add eax, 2
;    cmp eax, SCREEN_WIDTH * 2
;    jne put_char_end
;
;    call new_line
;
;put_char_end:
;    dec eax
;    mov [cursor_position_x], eax
;    
;    call update_cursor_pos
;
;    pop ebx
;    pop ecx
;    pop edx
;    ret

new_line:
    push ax
    push bx

    mov bx, 0
    mov ax, [cursor_position_y]
    inc ax

    call set_cursor_pos

    pop bx
    pop ax
    ret

section .data

cursor_position_x: dd 0
cursor_position_y: dd 0