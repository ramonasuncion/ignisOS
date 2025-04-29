# Debugging

// readelf -S build/kernel.elf
// strings build/kernel.elf
// hexdump -C build/kernel.bin
// x86_64-elf-objdump -s -j .rodata build/kernel.elf
// x86_64-elf-objdump -s -j .text build/kernel.elf
// x86_64-elf-objdump -h build/kernel.elf | grep "\.data " | awk '{print $4}'
//  x86_64-elf-objdump -h build/kernel.elf | grep "\.rodata" | awk '{print $4}'
// x86_64-elf-nm build/kernel.elf
// x86_64-elf-size --format=SysV build/kernel.elf
