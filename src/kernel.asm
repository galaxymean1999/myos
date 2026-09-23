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

    mov edx, VIDEO_MEMORY
    mov al, '/'
    mov ah, WHITE_ON_BLACK

    mov [edx], ax

    jmp $

section .data

gdt_start:
gdt_null:       ; null descriptor
    dd 0x0
    dd 0x0

gdt_code:           ; code segment descriptor
    dw 0xffff       ; limit (0-15)
    dw 0x0          ; base (0-15)
    db 0x0          ; base (16-23)
    db 10011010b    ; access byte: present, ring 0, code, exec
    dd 11001111b    ; flags (32 bit mode, 4kb) + limit (16-19)
    db 0x0          ; base (24-31)

gdt_data:           ; data segment descriptor
    dw 0xffff       ; limit (0-15)

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; 16 bit size of GDT
    dd gdt_start                ; 32 bit address of GDT

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start