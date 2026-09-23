;[org 0x7e00]
bits 16
global kernel

section .text
kernel:
    mov bx, string
    call print_str

    jmp $

; bx: pointer to the string
print_str:
    mov ah, 0x0e
print_loop:
    mov al, [bx]
    cmp al, 0
    je print_end
    int 0x10
    inc bx
    jmp print_loop
print_end:
    ret

section .data
string: db "Hello from the Disk!", 0