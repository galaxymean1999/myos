;[org 0x7e00]
bits 16
global kernel

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

section .text
kernel:
    call switch_to_protected_mode

    jmp $

switch_to_protected_mode:
    lgdt [gdt_descriptor]

    cli             ; turn off interrupts

    mov eax, cr0
    or eax, 0x1     ; set the first bit
    mov cr0, eax

    jmp CODE_SEG:init_pm

bits 32
init_pm:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp

    call clear_screen

    mov ax, 0x0f00 | '/'
    call put_char

    jmp $

; screen 80 x 25 chars
clear_screen:
    mov eax, 0
    mov [cursor_position_x], eax
    mov [cursor_position_y], eax
    mov ax, 0x0f00 | ' '
    mov ebx, 0
clear_screen_loop:
    push ebx
    call put_char
    pop ebx
    add ebx, 2
    cmp ebx, 80 * 2 * 25
    je clear_screen_end
    jmp clear_screen_loop
clear_screen_end:
    mov eax, 0
    mov ebx, 0
    call set_cursor_pos
    ret

; eax - cursor pos x
; ebx - cursor pos y
set_cursor_pos:
    mov [cursor_position_x], eax
    mov [cursor_position_y], ebx
    ret

; ax - char to put on screen at cursor pos
put_char:
    mov cx, ax
    mov eax, [cursor_position_x]
    mov ebx, [cursor_position_y]
    imul ebx, 80 * 2                ; cursor_position_x *= 80
    add eax, ebx                    ; eax += ebx
    mov edx, VIDEO_MEMORY
    add edx, eax                    ; edx - address of the current char
    mov [edx], cx

    mov eax, [cursor_position_x]
    add eax, 2
    cmp eax, 80 * 2
    je new_line
    mov [cursor_position_x], eax
    ret

new_line:
    mov eax, 0
    mov [cursor_position_x], eax
    mov eax, [cursor_position_y]
    inc eax
    mov [cursor_position_y], eax
    ret

section .data

cursor_position_x: dd 0
cursor_position_y: dd 0

gdt_start:
gdt_null:           ; null descriptor
    dd 0
    dd 0

gdt_code:           ; code segment descriptor
    dw 0xffff
    dw 0
    db 0
    db 10011010b
    db 11001111b
    db 0

gdt_data:           ; data segment descriptor
    dw 0xffff
    dw 0
    db 0
    db 10010010b
    db 11001111b
    db 0
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; 16 bit size of GDT
    dd gdt_start                ; 32 bit address of GDT

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start