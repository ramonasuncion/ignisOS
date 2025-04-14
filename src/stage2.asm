bits                 16
org                  0x8000             ; where stage2 loads

; constants
NULL_SEG             equ 0x00
CODE_SEG             equ 0x08
CODE64_SEG           equ 0x18
DATA_SEG             equ 0x10

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
KERNEL_SECTORS       equ 0x02           ; number of sectors to read

start:
    xor      ax, ax                     ; zero ax
    mov      ds, ax                     ; set up segments
    mov      es, ax

    mov      si, stage2_msg
    call     print_string

    ; fixme: I'm trying to load data to address 0x100000
    ; (1MB) while in 16-bit mode.

    ; disk loading
    ; mov bx, KERNEL_LOAD_ADDR
    ; mov ax, 0x1000 ; segment:offset
    ; mov es, ax
    ; mov bx, 0x0000
    ; mov dh, KERNEL_SECTORS
    ; mov dl, [boot_drive]
    ; call disk_load

    ; mov si, kernel_loaded_msg
    ; call print_string

    lgdt     [gdt_descriptor]           ; load gdt

    cli                                 ; disable interrupts before mode switch

                                        ; https://wiki.osdev.org/Protected_Mode
    mov      eax, cr0
    or       eax, 0x1                   ; set pe bit (bit 0) in cr0
    mov      cr0, eax

    jmp      CODE_SEG:protected_mode_start

    %include "disk.asm"
    %include "print.asm"

    align    8
gdt_start:
    dq       0x0000000000000000         ; null descriptor

gdt_code:
    dw       0xFFFF                     ; limit low
    dw       0x0000                     ; base low
    db       0x00                       ; base mid
    db       0x9A                       ; access byte: present, ring0, executable, readable
    db       0xCF                       ; flags: granularity=1, 32-bit protected mode (D=1, L=0)
    db       0x00                       ; base high

gdt_data:
    dw       0xFFFF                     ; limit low
    dw       0x0000                     ; base low
    db       0x00                       ; base mid
    db       0x92                       ; access: present, ring0, writable
    db       0xCF                       ; flags: granularity=1, 32-bit (D=1)
    db       0x00                       ; base high

gdt_code64:
    dw       0xFFFF                     ; limit low
    dw       0x0000                     ; base low
    db       0x00                       ; base mid
    db       0x9A                       ; access byte: present, ring0, executable, readable
    db       0xAF                       ; flags: granularity=1, L=1, D=0 (must be 0 for 64-bit)
    db       0x00                       ; base high

gdt_end:

gdt_descriptor:
    dw       gdt_end - gdt_start - 1    ; size of gdt minus 1
    dd       gdt_start                  ; address of gdt

bits                 32
protected_mode_start:
    mov      ax, DATA_SEG
    mov      ds, ax
    mov      es, ax
    mov      fs, ax
    mov      gs, ax
    mov      ss, ax

    mov      esp, 0x90000               ; setup stack

    call     setup_paging
    call     enable_long_mode

    lgdt     [gdt_descriptor]           ; reload same gdt

    jmp      CODE64_SEG:long_mode_start

setup_paging:
    ; clear memory for page tables
    mov      edi, PML4_ADDRESS          ; starting address for paging struct
    xor      eax, eax                   ; value to write (0)
    mov      ecx, 16384                 ; clear 64kb
    rep      stosd                      ; repeat store double word

    ; setup 4-level paging hierarchy
    mov      edi, PML4_ADDRESS
    mov      dword [edi], PDPT_ADDRESS | PAGE_PRESENT | PAGE_WRITE
    mov      dword [edi+4], 0

    mov      edi, PDPT_ADDRESS
    mov      dword [edi], PD_ADDRESS | PAGE_PRESENT | PAGE_WRITE
    mov      dword [edi+4], 0

    mov      edi, PD_ADDRESS
    mov      dword [edi], PT_ADDRESS | PAGE_PRESENT | PAGE_WRITE
    mov      dword [edi+4], 0

    ; setup identity mapping for first 2MB of memory
    mov      edi, PT_ADDRESS
    mov      ebx, PAGE_PRESENT | PAGE_WRITE
    mov      ecx, ENTRIES_PER_PT

.map:
    mov      dword [edi], ebx
    mov      dword [edi+4], 0
    add      ebx, PAGE_SIZE
    add      edi, PAGE_ENTRY_SIZE
    loop     .map

    mov      eax, PML4_ADDRESS
    mov      cr3, eax
    ret

enable_long_mode:
    ; https://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-vol-3a-part-1-manual.pdf - 3A section 9.8.5

    ; enable pae
    mov      eax, cr4
    or       eax, CR4_PAE               ; set pae bit
    mov      cr4, eax

    ; enable long mode in efer msr
    mov      ecx, EFER_MSR              ; efer msr
    rdmsr
    or       eax, EFER_LME              ; set lme bit
    wrmsr

    ; enable paging to activate long mode
    mov      eax, cr0
    or       eax, CR0_PG                ; set pg bit
    mov      cr0, eax

    ret

bits                 64
long_mode_start:
    ; clear segment registers
    xor      rax, rax
    mov      ds, ax
    mov      es, ax
    mov      ss, ax
    mov      fs, ax
    mov      gs, ax

    mov      rsp, 0x90000               ; setup 64-bit stack

    ; https://helparchive.huntertur.net/document/34458
    ; following code from: https://wiki.osdev.org/Entering_Long_Mode_Directly

    ; change background
    ; mov edi, 0xB8000                  ; vga text buffer
    ; mov rcx, 500
    ; mov rax, 0x1F201F201F201F20
    ; rep stosq

    ; ; display "Hello World!"
    ; mov edi, 0x00b8000

    ; mov rax, 0x1F6C1F6C1F651F48
    ; mov [edi],rax

    ; mov rax, 0x1F6F1F571F201F6F
    ; mov [edi + 8], rax

    ; mov rax, 0x1F211F641F6C1F72
    ; mov [edi + 16], rax

    mov      rax, KERNEL_LOAD_ADDR      ; load kernel
    jmp      rax                        ; jump to kernel entry point

    ; if kernel returns halt (?)

.hang:
    hlt                                 ; halt cpu
    jmp      .hang                      ; infinite loop

stage2_msg:
    db       'IgnisOS stage 2 loaded...', 13, 10, 0

kernel_loaded_msg:
    db       'Kernel loaded...', 13, 10, 0

    boot_drive db 0

