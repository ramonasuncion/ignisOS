ENTRY(_start)
OUTPUT_FORMAT("elf64-x86-64")

SECTIONS
{
  . = 0x00100000;               /* 1 MB kernel load address */

  .text : { *(.text) }
  .rodata : { *(.rodata) }
  .data : { *(.data) }

  __bss_start = .;
  .bss : { *(.bss COMMON) }
  __bss_end = .;

  . = ALIGN(16);
  __stack_start = .;
  . += 0x4000;                  /* 16 KiB stack */
  __stack_top = .;
}

