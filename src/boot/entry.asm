bits                 64
global               _start
extern               kmain

extern               _bss_start
extern               _bss_end

section              .text.boot
_start:
    ; todo: clear BSS section
    ; mov rdi, _bss_start
    ; mov rcx, _bss_end
    ; sub rcx, rdi
    ; xor rax, rax
    ; cld
    ; rep stosb

    ; setup kernel stack
    mov      rsp, stack_top
    mov      rbp, rsp
    and      rsp, -16                   ; 16-byte aligned

    ; call kernel main function
    call     kmain

    ;if kmain returns, halt the system
    cli
    hlt

section              .bss
    align    16
stack_bottom:
    resb     65536                      ; 64KB stack
stack_top:

