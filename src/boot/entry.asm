bits                 64
; section              .text
section              .text.boot
global               _start
extern               kmain
extern               stack_top

_start:
    ; clear BSS section
    ; extern bss
    ; extern end
    ; mov rdi, bss
    ; mov rcx, end
    ; sub rcx, rdi
    ; xor rax, rax
    ; rep stosb        ; zero out the BSS section

    ; Set up stack
    mov      rsp, stack_top
    mov      rbp, rsp
    and      rsp, -16                   ; align the stack to 16 bytes

    call     kmain                      ; jump to kernel main function

.hang:
    hlt
    jmp      .hang

