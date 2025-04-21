# IgnisOS

A hobby osdev project. I intend to develop a x64 monolothic OS.

## Demo

![OS](./os_demo.png)

## Deps

You will need the following tools:

- compiler : `gcc`
- assembler: `nasm`
- linker   : `gnu ld`
- emulator : `qemu`

Developing on Debian:

```sh
sudo apt install build-essential gcc-multilib nasm make binutils
```

- [OSDev - GCC Cross Compiler](https://wiki.osdev.org/GCC_Cross-Compiler)
- [Debian - QEMU](https://wiki.debian.org/QEMU)

## Debugging

- `gdb`
- `xxd` - see the binary data (xxd boot.bin)
- `spellcheck` -  a static analysis tool for shell scripts

Developing on Debian:

```sh
sudo apt install gdb
sudo apt install shellcheck
```

## Contribs

I welcome contributions to the project. Please read [CONTRIBUTING.md](./CONTRIBUTING.md).

## IgnisOS Specification

This is what I plan to include in my kernel (things might change):

- Architecture:          64-bit (x86_64)
- Scheduling:            Non-preemptive
- Tasking:               Cooperative multi-tasking
- Cores:                 Multi-core support (SMP)
- Privilege Level:       Ring-0-only (no user/kernel separation)
- Memory Model:          Single address space (flat memory model)
- Networking:            Supported (basic TCP/IP stack)
- Graphics:              VBE 1024x768 @ 32bpp (16-color / 32-entry palette mode emulation)
- Text Encoding:         8-bit ASCII (no Unicode)
- Input:                 PS/2 Keyboard + Mouse
- File System:           Custom (or FAT12/FAT32)
- Scriping Language:     Aurum

## Tasks

Minimal Kernel

- [x] Boot to long mode
- [x] Setup GDT, paging, and 64-bit mode
- [x] Disk loading (stage 2 + kernel)
- [x] Flat memory model (partial: identity mapping for first 2MB)
- [x] Kernel-only mode (Ring 0)
- [ ] IDT, IRQ, and basic ISRs
- [ ] Memory mapping and basic protections
- [ ] Timer (delays and scheduling tasks e.g., PIT or HPET)
- [ ] Memory mapping (full identity mapping)
- [ ] Memory allocation (kernel heap allocator)
- [ ] Minimal memory protections (read-only sections, guard pages)
- [ ] Print function in x64
- [ ] Start screen
- [ ] VGA-based text UI
- [ ] Resizable UI
- [ ] Font system (Fixed Sys or some 8x8 bitmap font)
    - [font8x8](https://github.com/dhepper/font8x8)
- [ ] Keyboard input
- [ ] Mouse support
- [ ] Basic shell
- [ ] Built-in text editor
- [ ] Scripting language (Aurum)
- [ ] Executable/script format support
- [ ] Symbol table / reflection
- [ ] File system (FAT12)
- [ ] File loading (scripts/programs)
- [ ] PCI support
- [ ] Basic scheduler (non-preemptive round robin)
- [ ] Task model / cooperative multitasking
- [ ] System call interface
- [ ] Math / drawing library (+ demo programs)
- [ ] Graphics in text mode (optional hybrid mode)
- [ ] Sound output
- [ ] Basic networking stack
- [ ] Debugging tools / logging
- [ ] Panic and fault handler (stack dump, message)
- [ ] Step/debug trap
- [ ] Boot self-test / diagnostics

## Reading List

1. Operating Systems: Design and Implementation (Second Edition) 2nd Edition
by Andrew S. Tanenbaum (Author), Albert S. Woodhull (Author) - Thanks to Professor Xiannong Meng at Bucknell University.

2. Operating System Concepts, 5th Edition 5th Edition
by Abraham Silberschatz (Author), Bill Zorbrist (Author), Peter Galvin (Author) - Thanks to Professor Jessen Havill at Bucknell Univeristy.

