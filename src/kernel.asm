;[org 0x7e00]
bits 16
global kernel

VIDEO_MEMORY equ 0xb8000

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

    mov ax, 0x0f00 | '/'
    call put_char

    mov eax, hello_string
    mov bx, 0x0f00
    call print_str

    jmp $

; screen 80 x 25 chars
clear_screen:
    push eax
    push ebx

    mov eax, 0
    mov ax, 0x0f00 | ' '
    mov ebx, VIDEO_MEMORY
clear_screen_loop:
    mov [ebx], ax
    add ebx, 2
    cmp ebx, VIDEO_MEMORY + 80*25*2
    jne clear_screen_loop
clear_screen_end:
    xor eax, eax
    mov ebx, 0
    call set_cursor_pos

    pop ebx
    pop eax
    ret

; eax - cursor pos x
; ebx - cursor pos y
set_cursor_pos:
    mov [cursor_position_x], eax
    mov [cursor_position_y], ebx
    ret

; eax - char *
; bh - char color << 8 bits
print_str:
    push ecx

    mov ecx, eax
    mov ax, bx
print_loop:
    mov ax, bx
    mov al, [ecx]
    cmp al, 0
    jz print_end

    push ecx
    push ebx
    call put_char
    pop ebx
    pop ecx

    inc ecx
    jmp print_loop
print_end:
    pop ecx
    ret

; ax - char to put on screen at cursor pos
put_char:
    ; preserve registers that are in use by subroutine
    push edx
    push ecx
    push ebx

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
    jne put_char_end
    call new_line

put_char_end:
    mov [cursor_position_x], eax

    pop ebx
    pop ecx
    pop edx
    ret

new_line:
    push eax

    mov eax, 0
    mov [cursor_position_x], eax
    mov eax, [cursor_position_y]
    inc eax
    mov [cursor_position_y], eax

    pop eax
    ret

section .data

hello_string: db "Patrik smrdi jak hovno u cesty", 0

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