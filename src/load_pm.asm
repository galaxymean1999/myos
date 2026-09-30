;[org 0x7e00]
bits 16
global switch_to_protected_mode

extern main
extern clear_screen

section .text
switch_to_protected_mode:
    lgdt [gdt_descriptor]

    cli             ; turn off interrupts

    mov eax, cr0
    or eax, 0x1     ; set the first bit
    mov cr0, eax

    jmp CODE_SEG:init_pm

;
; PROTECTED 32 BIT MODE
;
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

pm_start:
    jmp main

section .data

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