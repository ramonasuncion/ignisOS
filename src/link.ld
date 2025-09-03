OUTPUT_FORMAT("elf64-x86-64")
ENTRY(_start) /* switch between kmain / _start based on if I want .entry.asm to have instruction or straight to kernel if I do everything in the bootloader*/
SECTIONS
{
  . = 0x00100000;
  .text : { *(.text) }
  .rodata : { *(.rodata) }
  .data : { *(.data) }
  .bss : { *(.bss COMMON) }
}
