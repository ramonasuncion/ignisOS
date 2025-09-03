bits                 16
org                  0x8000             ; where stage2 loads

; todo: check if long mode enable sequence is good. i feel ike it's everywhere the sequence (after protect ed mode)
; todo: recheck the page-table for 64 bit entries
; todo: i'm reading cr3 before the tables are even ready

; constants
; NULL_SEG             equ 0x00
; CODE_SEG             equ 0x08
; CODE64_SEG           equ 0x18
; DATA_SEG             equ 0x10

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
KERNEL_SECTORS       equ 0x32           ; number of sectors to read

;%ifndef KERNEL_SECTORS
;%error "KERNEL_SECTORS not defined"
;%endif

; bits                 16
start:
    xor      ax, ax                     ; zero ax
    mov      ds, ax                     ; set up segments
    mov      es, ax

    mov      si, stage2_msg
    call     print_string

    ; TODO: setup base pointer and stack pointer
    mov      bp, 0x0500
    mov      sp, bp

    mov      bx, 0x9000                 ; temporary buffer
    mov      dh, KERNEL_SECTORS         ; number of sectors to read
    mov      dl, [boot_drive]           ; boot drive number
    mov      cl, 0x09
    call     disk_load

    mov      si, kernel_loaded_msg
    call     print_string

    lgdt     [gdt_descriptor32]           ; load gdt

    cli                                 ; disable interrupts before mode switch

    mov      eax, cr0
    or       eax, 0x1                   ; set pe bit (bit 0) in cr0
    mov      cr0, eax

    jmp      CODE32_SEG:protected_mode_start

%include "disk.asm"
%include "print.asm"

    ; align    8
gdt_start32:
    ; null descriptor
    ; dq       0x0000000000000000         ; null descriptor
    dd       0x00000000
    dd       0x00000000

gdt_code32:
    dw       0xFFFF                     ; limit low
    dw       0x0000                     ; base low
    db       0x00                       ; base mid
    db       0x9A                       ; access byte: present, ring0, executable, readable
    db       0xCF                       ; flags: granularity=1, 32-bit protected mode (D=1, L=0)
    db       0x00                       ; base high

gdt_data32:
    dw       0xFFFF                     ; limit low
    dw       0x0000                     ; base low
    db       0x00                       ; base mid
    db       0x92                       ; access: present, ring0, writable
    db       0xCF                       ; flags: granularity=1, 32-bit (D=1)
    db       0x00                       ; base high

gdt_end32:

gdt_descriptor32:
    dw       gdt_end32 - gdt_start32 - 1    ; size of gdt minus 1
    dd       gdt_start32                  ; address of gdt


CODE32_SEG: equ gdt_code32 - gdt_start32
DATA32_SEG: equ gdt_data32 - gdt_start32

bits                 32
protected_mode_start:
    mov      ax, DATA32_SEG
    mov      ds, ax
    mov      es, ax
    mov      fs, ax
    mov      gs, ax
    mov      ss, ax

    mov      ebp, 0x90000               ; setup stack
    mov      esp, ebp ; esp

    call     setup_paging
    call     enable_long_mode

    lgdt     [gdt_descriptor64]

    jmp      CODE64_SEG:long_mode_start

; gdt_code64:
;     dw       0xFFFF                     ; limit low
;     dw       0x0000                     ; base low
;     db       0x00                       ; base mid
;     db       0x9A                       ; access byte: present, ring0, executable, readable
;     db       0xAF                       ; flags: granularity=1, L=1, D=0 (must be 0 for 64-bit)
;     db       0x00                       ; base high

    ; align    8
    align    4
gdt_start64:
    ; null descriptor
    ; dq       0x0000000000000000         ; null descriptor
    dd       0x00000000
    dd       0x00000000

gdt_code64:
    dw       0xFFFF                     ; limit low
    dw       0x0000                     ; base low
    db       0x00                       ; base mid
    db       0x9A                       ;
    db       0xAF                       ;
    db       0x00                       ; base high

gdt_data64:
    dw       0xFFFF                     ; limit low
    dw       0x0000                     ; base low
    db       0x00                       ; base mid
    db       0x92                       ;
    db       0xA0                       ;
    db       0x00                       ; base high

gdt_end64:

gdt_descriptor64:
    dw       gdt_end64 - gdt_start64 - 1  ; size of gdt minus 1
    dd       gdt_start64                  ; address of gdt

CODE64_SEG: equ gdt_code64 - gdt_start64
DATA64_SEG: equ gdt_data64 - gdt_start64

setup_paging:
    pushad

    ; clear the memory area
    mov edi, 0x1000
    mov cr3, edi
    xor eax, eax
    mov ecx, 4096
    rep stosd

    ; set edi back to PML4T[0]
    mov edi, cr3

    mov dword[edi], 0x2003
    add edi, 0x1000
    mov dword[edi], 0x3003
    add edi, 0x1000
    mov dword[edi], 0x4003

    add edi, 0x1000
    mov ebx, 0x00000003
    mov ecx, 512

    add_page_entry_protected:
        mov dword[edi], ebx
        add ebx, 0x1000
        add edi, 8
        loop add_page_entry_protected

    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    popad
    ret


; setup_paging:
;     ; clear memory for page tables
;     mov      edi, PML4_ADDRESS          ; starting address for paging struct
;     xor      eax, eax                   ; value to write (0)
;     mov      ecx, 16384                 ; clear 64kb
;     rep      stosd                      ; repeat store double word

;     ; setup 4-level paging hierarchy
;     mov      edi, PML4_ADDRESS          ; Fixed typo here
;     mov      dword [edi], PDPT_ADDRESS | PAGE_PRESENT | PAGE_WRITE
;     mov      dword [edi+4], 0

;     mov      edi, PDPT_ADDRESS
;     mov      dword [edi], PD_ADDRESS | PAGE_PRESENT | PAGE_WRITE
;     mov      dword [edi+4], 0

;     mov      edi, PD_ADDRESS
;     mov      dword [edi], PT_ADDRESS | PAGE_PRESENT | PAGE_WRITE
;     mov      dword [edi+4], 0

;     ; setup identity mapping for first 2MB of memory
;     mov      edi, PT_ADDRESS
;     xor      ebx, ebx                   ; start at physical address 0
;     ; mov      ecx, ENTRIES_PER_PT
;     mov      ecx, 1024

; .map_loop:
;     mov      eax, ebx
;     or       eax, PAGE_PRESENT | PAGE_WRITE
;     mov      dword [edi], eax
;     mov      dword [edi+4], 0

;     add      ebx, PAGE_SIZE
;     add      edi, PAGE_ENTRY_SIZE
;     loop     .map_loop

;     mov      eax, PML4_ADDRESS
;     mov      cr3, eax

;     mov      eax, cr3
;     mov      cr3, eax

;     ret

; .map_loop:
;     ; Map .text section (read-only, executable)
;     cmp      ebx, 0x101000              ; start of .rodata
;     jb       .map_text
;     cmp      ebx, 0x102000              ; end of .rodata
;     jae      .map_normal

;     ; Map .rodata section as read-only
;     mov      eax, ebx
;     or       eax, PAGE_PRESENT          ; read-only (no PAGE_WRITE)
;     mov      dword [edi], eax
;     jmp      .next_entry

; .map_text:
;     ; Map .text section as read-only
;     mov      eax, ebx
;     or       eax, PAGE_PRESENT          ; read-only (no PAGE_WRITE)
;     mov      dword [edi], eax
;     jmp      .next_entry

; .map_normal:
;     ; Map other sections as read-write
;     mov      eax, ebx
;     or       eax, PAGE_PRESENT | PAGE_WRITE
;     mov      dword [edi], eax

; .next_entry:
;     mov      dword [edi+4], 0
;     add      ebx, PAGE_SIZE             ; next 4K page
;     add      edi, PAGE_ENTRY_SIZE       ; next entry
;     loop     .map_loop

;     ; Set cr3 to point to the PML4 table
;     mov      eax, PML4_ADDRESS
;     mov      cr3, eax

;     ret

enable_long_mode:
    ; enable pae
    ; mov      eax, cr4
    ; or       eax, CR4_PAE               ; set pae bit
    ; mov      cr4, eax

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
    mov      ax, DATA64_SEG
    ; xor      ax, ax
    mov      ds, ax                     ; data segment
    mov      es, ax                     ; extra segment
    mov      ss, ax                     ; stack segment
    mov      fs, ax
    mov      gs, ax

    wbinvd                              ; flush the cache

    mov      rsp, 0x90000               ; setup 64-bit stack

    mov      rsi, 0x9000                ; source (temp buffer)
    mov      rdi, KERNEL_LOAD_ADDR      ; destination (1MB)
    mov      rcx, KERNEL_SECTORS * 512  ; size in bytes (sectors * 512)
    rep      movsb                      ; copy byte by byte

    mov      rax, KERNEL_LOAD_ADDR      ; load kernel
    call     rax                        ; jump to kernel entry point
    jmp      .hang

    ; if kernel returns halt (?)

.hang:
    hlt                                 ; halt cpu
    jmp      .hang                      ; infinite loop

stage2_msg:
    db       'IgnisOS stage 2 loaded...', 13, 10, 0

kernel_loaded_msg:
    db       'Kernel loaded...', 13, 10, 0

boot_drive db 0

