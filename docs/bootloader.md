# Bootloader

I am using `qemu` to emulate a computer.

I'm creating a 1.44 MB floppy [disk image](https://wiki.osdev.org/Disk_Images) for my OS.

The **kernel** is a binary file (in ELF format) stored within this image.

The BIOS tries to find the OS at a known location: the first sector of the disk, also known as the Master Boot Record (MBR)

The problem is a sector size is typically only 512 bytes (very small).

Therefore, I'm building a two stage bootloader where stage 1 fits in wthin 512 bytes limt and finds the second stage to load in the full OS in the disk.

The BIOS loads the bootloader's code into address 0x7C00.

The MBR ust end with the **boot signature** `0x55AA` at the last two bytes.


