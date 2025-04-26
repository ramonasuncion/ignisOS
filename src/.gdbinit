target remote :1234
symbol-file build/kernel.elf
add-symbol-file build/kernel.elf 0x100000
set disassembly-flavor intel
