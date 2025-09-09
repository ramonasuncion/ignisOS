target remote :1234
set disassembly-flavor intel
symbol-file build/kernel.elf
b kmain
c
layout src
n
n
