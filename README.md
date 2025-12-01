# IgnisOS

A hobby osdev project. I intend to develop a x64 monolothic OS.

## Demo

![OS](./os_demo.png)

## Deps

You will need the following tools:

- compiler : `gcc`
- assembler: `nasm`
- linker : `gnu ld`
- emulator : `qemu`

Developing on Debian:

```sh
sudo apt install build-essential gcc-multilib nasm make binutils
```

- [OSDev - GCC Cross Compiler](https://wiki.osdev.org/GCC_Cross-Compiler)
- [Debian - QEMU](https://wiki.debian.org/QEMU)
- [Limine](https://github.com/limine-bootloader/limine)

> [!NOTE]  
> A Limine-compatible bootloader needs to be available
> Download the Limine release (v10.x-binary) and place it in the
> repository root as `limine/` or update `src/Makefile`.

## Debugging

- `gdb`
- `xxd` - see the binary data (xxd boot.bin)
- `spellcheck` - a static analysis tool for shell scripts

Developing on Debian:

```sh
sudo apt install gdb
sudo apt install shellcheck
```

## Contribution

I welcome contributions to the project. Please read [CONTRIBUTING.md](./CONTRIBUTING.md).

## Reading List

1. Operating Systems: Design and Implementation (Second Edition) 2nd Edition
   by Andrew S. Tanenbaum (Author), Albert S. Woodhull (Author) - Thanks to Professor Xiannong Meng at Bucknell University.

2. Operating System Concepts, 5th Edition 5th Edition
   by Abraham Silberschatz (Author), Bill Zorbrist (Author), Peter Galvin (Author) - Thanks to Professor Jessen Havill at Bucknell Univeristy.
