bits 32

global kernel

extern main

section .text

kernel:
    mov ebp, 0x90000
    mov esp, ebp

    call main

    jmp $

section .data