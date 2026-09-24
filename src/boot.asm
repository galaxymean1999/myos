;[org 0x7c00]
bits 16
global start

section .text
start:
    ; clear registers to 0
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00

    mov [BOOT_DRIVE], dl

    mov bx, 0x7e00
    mov al, 1
    call read_disk

    jmp 0x7e00

    jmp $

; al - num of sectors to read
read_disk:
    mov ah, 0x02
    mov ch, 0       ; cylinder
    mov dh, 0       ; head
    mov cl, 0x02    ; sector to start on - 1 is the bootloader
    mov dl, [BOOT_DRIVE]
    int 0x13
    jc error_code   ; if carry bit set (if loading failed)
    ret

; ah - error code
error_code:
    mov ah, 0x0e
    mov al, 'e'
    int 0x10
    ret

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
BOOT_DRIVE db 0