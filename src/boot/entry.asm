bits 64
section .text
global _start
extern __bss_start
extern __bss_end
extern __stack_top
extern kmain

_start:
    ; zero BSS
     mov rdi, __bss_start
     mov rdx, __bss_end
     cmp rdx, rdi
     jbe .no_bss_clear    ; if end <= start, skip clearing
     sub rdx, rdi         ; rdx = size
     mov rcx, rdx
     xor rax, rax
     cld
     rep stosb
.no_bss_clear:

    ; set up stack
    mov rsp, __stack_top
    and rsp, -16     ; align to 16 bytes
    xor rbp, rbp

    ; jump to kernel C entry
    call kmain

.hang:
    hlt
    jmp .hang

