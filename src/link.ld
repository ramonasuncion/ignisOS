ENTRY(_start)

SECTIONS
{
  /* Kernel starts at 1MB physical address */
  . = 0x100000;

  _start = .;

  .text :
  {
    *(.text.boot)  /* Boot code first */
    *(.text)       /* Regular code */
    *(.text.*)
  }

  .rodata :
  {
    *(.rodata)
    *(.rodata.*)
  }

  .data ALIGN(4K) :
  {
    *(.data)
  }

  .bss :
  {
    _bss_start = .;
    *(COMMON)
    *(.bss)
    _bss_end = .;
  }

  _end = .;
}
