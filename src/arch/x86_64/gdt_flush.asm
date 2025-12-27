[bits 64]
global gdt_flush
extern gp

section .text

gdt_flush:
    lgdt [gp]
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    push 0x08
    lea rax, [rel flush2]
    push rax
    retfq
flush2:
    ret