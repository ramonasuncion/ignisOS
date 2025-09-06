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
    mov rcx, __bss_end
    sub rcx, rdi
    xor rax, rax
    rep stosb

    ; set up stack
    mov rsp, __stack_top
    and rsp, -16     ; align to 16 bytes
    xor rbp, rbp

    ; jump to kernel C entry
    call kmain

.hang:
    hlt
    jmp .hang

