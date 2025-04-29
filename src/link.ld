ENTRY(_start)
OUTPUT_FORMAT(elf64-x86-64)
OUTPUT_ARCH(i386:x86-64)

KERNEL_PHYS_START = 0x100000;

SECTIONS {
  . = KERNEL_PHYS_START;

  .text : ALIGN(4K) {
    *(.text.boot)
    *(.text*)
  }

  .rodata : ALIGN(4K) {
    *(.rodata*)
  }

  .data : ALIGN(4K) {
    *(.data*)
  }

  .bss : ALIGN(4K) {
    *(COMMON)
    *(.bss*)

    . = ALIGN(16);
    stack_bottom = .;
    . += 16384;
    stack_top = .;
  }

  /DISCARD/ : {
    *(.comment)
    *(.eh_frame*)
  }

  kernel_end = .;
}