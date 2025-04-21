ENTRY(_start)
OUTPUT_FORMAT("elf64-x86-64")
SECTIONS
{
  . = 0x100000;    /* Kernel loads at 1MB */

  .text : {
    *(.text)
  }

  .rodata : {
    *(.rodata)
  }

  .data : {
    *(.data)
  }

  .bss : {
    *(.bss)
    *(COMMON)
  }
}
