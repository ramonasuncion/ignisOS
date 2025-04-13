# IgnisOS

A hobby osdev project. I intend to develop a x86_64 monolothic OS.

## Demo

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

Developing on Debian:

```sh
sudo apt install gdb
```

## Contribs

I welcome contributions to the project. Please read [CONTRIBUTING.md](./CONTRIBUTING.md).

## Plans

- FAT12 FS + multiple FS
- Full kernel privileges
- Schedule / Multitasking
  - Single-threaded and non-preemptive
- Basic shell
- System calls

