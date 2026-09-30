bits 32

global kernel

extern c_main

section .text

kernel:
    mov ebp, 0x90000
    mov esp, ebp

    call c_main

    jmp $

section .data

hello_string: db "Patrik smrdi jak hovno u cesty", 0