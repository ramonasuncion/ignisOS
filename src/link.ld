ENTRY(_start)

SECTIONS
{
  /* Kernel starts at 1MB physical address */
  . = 0x100000;

  _start = .;

  .text ALIGN(16) : 
  {
    *(.text.boot)  /* Boot code first */
    *(.text)       /* Regular code */
    *(.text.*)
  }

  .rodata ALIGN(16) :
  {
    *(.rodata)
    *(.rodata.*)
  }
  _rodata_end = .;

  .data ALIGN(16) :
  {
    *(.data)
  }
  _data_end = .;

  .bss ALIGN(16) :
  {
    _bss_start = .;
    *(COMMON)
    *(.bss)
    _bss_end = .;
  }

  /DISCARD/ :
  {
    *(.comment)
    *(.eh_frame)
    *(.note.gnu.build-id)
  }

  _end = .;
}