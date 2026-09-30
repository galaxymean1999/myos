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

hello_string: db "Patrik smrdi jak hovno u cesty", 0