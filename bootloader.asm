[org 0x7c00]

start:
    mov ebx, string
    call print_str

    jmp $

; ebx: pointer to the string
print_str:
    mov ah, 0x0e
print_loop:
    mov al, [ebx]
    cmp al, 0
    je print_end
    int 0x10
    inc ebx
    jmp print_loop
print_end:
    ret

string: db "Hello, World!", 0

times 510-($-$$) db 0
dw 0xaa55