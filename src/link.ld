ENTRY(kmain)
OUTPUT_FORMAT("elf64-x86-64")

PHDRS
{
    limine_requests PT_LOAD;
    text PT_LOAD;
    rodata PT_LOAD;
    data PT_LOAD;
}

SECTIONS
{
    . = 0xffffffff80000000;

    .limine_requests : {
        KEEP(*(.limine_requests_start))
        KEEP(*(.limine_requests))
        KEEP(*(.limine_requests_end))
    } :limine_requests

    . = ALIGN(CONSTANT(MAXPAGESIZE));

    .text : {
        *(.text .text.*)
    } :text

    . = ALIGN(CONSTANT(MAXPAGESIZE));

    .rodata : {
        *(.rodata .rodata.*)
    } :rodata

    .note.gnu.build-id : {
        *(.note.gnu.build-id)
    } :rodata

    . = ALIGN(CONSTANT(MAXPAGESIZE));

    .data : {
        *(.data .data.*)
    } :data

    .bss : {
        __bss_start = .;
        *(.bss .bss.* COMMON)
        __bss_end = .;
    } :data

    . = ALIGN(16);
    __stack_start = .;
    . += 0x4000;
    __stack_top = .;

    /DISCARD/ : {
        *(.eh_frame*)
        *(.comment)
        *(.note)
        *(.note.*)
    }
}
