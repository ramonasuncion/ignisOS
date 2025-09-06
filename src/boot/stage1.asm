bits                 16
org                  0x7C00

SECOND_STAGE_LOAD_ADDR equ 0x8000       ; location to load second stage
SECOND_STAGE_SECTORS equ 8              ; number of sectors for second stage

start:
    cli                                 ; disable interrupts
    xor      ax, ax                     ; zero ax
    mov      ds, ax                     ; set up segments
    mov      es, ax
    mov      ss, ax
    mov      sp, 0x7C00                 ; set stack just below bootloader
    sti                                 ; re-enable interrupts

    mov      [boot_drive], dl           ; save boot drive

    mov      si, stage1_msg
    call     print_string
    call     print_newline

    call     enable_a20                 ; enable A20 gate for memory access above 1MB

    ; setup buffer pointer
    ; real mode 16 bit (segment:offset)
    mov      ax, SECOND_STAGE_LOAD_ADDR >> 4
    mov      es, ax
    mov      bx, SECOND_STAGE_LOAD_ADDR & 0xF

    ; setup BIOS registes
    mov      al, SECOND_STAGE_SECTORS   ; number of sectors
    mov      ch, 0                      ; cylinder 0
    mov      cl, 2                      ; load sector 2
    mov      dh, 0                      ; head 0
    mov      dl, [boot_drive]           ; boot drive

    call     disk_load

    jmp      0x0000:SECOND_STAGE_LOAD_ADDR

enable_a20:
    in       al, 0x92                   ; fast a20 gate
    or       al, 2                      ; set a20 bit
    out      0x92, al
    ret

%include "disk.asm"
%include "print.asm"

stage1_msg:
    db       'IgnisOS stage 1 loaded...', 0

boot_drive db 0

times    510-($-$$) db 0            ; pad to 510 bytes
dw       0xAA55                     ; boot signature

