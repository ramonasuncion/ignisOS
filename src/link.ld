OUTPUT_FORMAT("elf64-x86-64")
ENTRY(_start)
phys = 0x100000;
SECTIONS
{
  .text phys : AT(phys) {
    code = .;
    *(.text)
    /* *(.rodata) */
    . = ALIGN(4096);
  }
  .rodata : AT(phys + (rodata - code))
  {
    rodata = .;
    *(.rodata)
    *(.rodata.*)
    . = ALIGN(4096);
  }
  .data : AT(phys + (data - code))
  {
    data = .;
    *(.data)
    . = ALIGN(4096);
  }
  .bss : AT(phys + (bss - code))
  {
    bss = .;
    *(.bss)
    . = ALIGN(4096);
  }
  end = .;
}