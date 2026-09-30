bits 32

global main

extern clear_screen
extern set_cursor_pos
extern print_str
extern put_char
extern new_line

section .text

main:
    mov eax, hello_string
    mov bx, 0x0f00
    call print_str

    mov bx, 4
    mov ax, 1
    call set_cursor_pos

    mov ah, 0x0f
    mov al, '/'
    call put_char

    jmp $

section .data

hello_string: db "Patrik smrdi jak hovno u cesty", 0