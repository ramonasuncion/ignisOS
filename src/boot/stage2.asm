bits                 16
org                  0x8000             ; where stage2 loads

; page table constants
PAGE_PRESENT         equ (1 << 0)
PAGE_WRITE           equ (1 << 1)
PAGE_SIZE            equ 0x1000         ; 4KB pages
PAGE_ENTRY_SIZE      equ 8              ; each entry is 8 bytes
ENTRIES_PER_PT       equ 512            ; 512 entries per page table

; memory locations for page tables
PML4_ADDRESS         equ 0x70000
PDPT_ADDRESS         equ 0x71000
PD_ADDRESS           equ 0x72000
PT_ADDRESS           equ 0x73000

; cpu register bit flags
CR4_PAE              equ (1 << 5)       ; physical address extension
CR0_PG               equ (1 << 31)      ; paging enabled
EFER_MSR             equ 0xC0000080     ; extended feature enable register
EFER_LME             equ (1 << 8)       ; long mode enable

; disk loading constants
KERNEL_LOAD_ADDR     equ 0x100000       ; kernel location at 1 MB

%ifndef KERNEL_SECTORS
%error "KERNEL_SECTORS not defined"
%endif

start:
; real mode / 16-bit
    xor      ax, ax
    mov      ds, ax
    mov      es, ax

    ; temp stack
    mov      bp, 0x0500
    mov      sp, bp

    mov      si, .stage2_msg
    call     print_string

    ;mov      ax, KERNEL_LOAD_ADDR
    ;mov      es, ax
    ;mov      di, 0

    ;mov      al, KERNEL_SECTORS         ; number of sectors to read
    ;mov      ch, 0                      ; cylinder 0
    ;mov      dh, 0                      ; head 0
    ;mov      cl, 9                      ; starting sector (sector 9)
    ;mov      dl, [boot_drive]           ; boot drive number
    ;call     disk_load

    mov      si, .kernel_loaded_msg
    call     print_string

    ; load gdt for 32-bit protected mode
    lgdt     [gdt_descriptor32]
    cli
    mov      eax, cr0
    or       eax, 1                     ; set PE bit
    mov      cr0, eax

    jmp      CODE32_SEG:protected_mode_start

.stage2_msg:
    db       'IgnisOS stage 2 loaded...', 13, 10, 0

.kernel_loaded_msg:
    db       'Kernel loaded...', 13, 10, 0

%include "disk.asm"
%include "print.asm"

align    8
gdt_start32:
    dd 0
    dd 0

gdt_code32:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 0x9A
    db 0xCF
    db 0x00

gdt_data32:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 0x92
    db 0xCF
    db 0x00

gdt_end32:

gdt_descriptor32:
    dw gdt_end32 - gdt_start32 - 1
    dd gdt_start32


CODE32_SEG: equ gdt_code32 - gdt_start32
DATA32_SEG: equ gdt_data32 - gdt_start32

bits 32
protected_mode_start:
    ; reload segments
    mov      ax, DATA32_SEG
    mov      ds, ax
    mov      es, ax
    mov      fs, ax
    mov      gs, ax
    mov      ss, ax

    mov      ebp, 0x90000               ; setup stack
    mov      esp, ebp

    ; build page tages (identity map first 2 MiB)
    call     setup_paging

    ; enable long mode (EFER.LME then CR0.PG)
    call     enable_long_mode

    ; load 64-bit GDT then jump to long mode start
    lgdt     [gdt_descriptor64]
    jmp      CODE64_SEG:long_mode_start

align 4
gdt_start64:
    dd 0
    dd 0

gdt_code64:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 0x9A
    db 0xAF
    db 0x00

gdt_data64:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 0x92
    db 0xA0
    db 0x00

gdt_end64:

gdt_descriptor64:
    dw gdt_end64 - gdt_start64 - 1
    dd gdt_start64

CODE64_SEG: equ gdt_code64 - gdt_start64
DATA64_SEG: equ gdt_data64 - gdt_start64

setup_paging:
    pushad

    ; clear 16KiB area at PML4_ADDRESS (PML4, PDPT, PD, PT) to zero
    mov      edi, PML4_ADDRESS
    xor      eax, eax
    mov      ecx, 4096         ; 16KiB / 4 = 4096 dwords
    rep      stosd

    mov      edi, PT_ADDRESS
    xor      ebx, ebx
    mov      ecx, 512
.fill_pt_loop:
    mov      eax, ebx
    or       eax, PAGE_PRESENT | PAGE_WRITE
    mov      dword [edi], eax
    mov      dword [edi+4], 0
    add      ebx, PAGE_SIZE
    add      edi, PAGE_ENTRY_SIZE
    loop     .fill_pt_loop

    ; PD[0] -> PT (write low dword then high dword)
    mov      eax, PT_ADDRESS
    or       eax, PAGE_PRESENT | PAGE_WRITE
    mov      dword [PD_ADDRESS], eax
    mov      dword [PD_ADDRESS + 4], 0

    ; PDPT[0] -> PD
    mov      eax, PD_ADDRESS
    or       eax, PAGE_PRESENT | PAGE_WRITE
    mov      dword [PDPT_ADDRESS], eax
    mov      dword [PDPT_ADDRESS + 4], 0

    ; PML4[0] -> PDPT
    mov      eax, PDPT_ADDRESS
    or       eax, PAGE_PRESENT | PAGE_WRITE
    mov      dword [PML4_ADDRESS], eax
    mov      dword [PML4_ADDRESS + 4], 0

    ; enable PAE (CR4.PAE)
    mov      eax, cr4
    or       eax, CR4_PAE
    mov      cr4, eax

    ; load CR3 with physical address of PML4
    mov      eax, PML4_ADDRESS
    mov      cr3, eax

    popad
    ret

enable_long_mode:
    ; ECX = MSR
    mov      ecx, EFER_MSR              ; efer msr
    rdmsr
    or       eax, EFER_LME              ; set lme bit
    wrmsr

    ; enable paging (CR0.PG)
    mov      eax, cr0
    or       eax, CR0_PG                ; set pg bit
    mov      cr0, eax
    ret

bits 64
long_mode_start:
    ; setup 64-bit segments
    mov      ax, DATA64_SEG
    mov      ds, ax
    mov      es, ax
    mov      ss, ax
    mov      fs, ax
    mov      gs, ax

    wbinvd                              ; flush caches
    mov      rsp, 0x90000               ; setup 64-bit stack


    ; TODO: I'm I copying everything properly?
    mov      rsi, 0x9000
    mov      rdi, KERNEL_LOAD_ADDR
    mov      rcx, KERNEL_SECTORS * 512
    rep      movsb

    mov      rax, KERNEL_LOAD_ADDR      ; load kernel (alredy copied to 1MB)
    call     rax                        ; jump to kernel entry point

.hang:
    hlt                                 ; halt cpu
    jmp      .hang                      ; infinite loop


boot_drive db 0

