# IgnisOS

A hobby osdev project. I intend to develop a x64 monolothic OS.

## Demo

![OS](./demo.png)

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

## Tasks

Minimal Kernel

- [x] Boot to long mode
- [x] Setup GDT, paging, and 64-bit mode
- [ ] Disk loading (stage 2 + kernel)
- [ ] Memory mapping and basic protections
- [ ] Timer (delays and scheduling tasks e.g., PIT or HPET)
- [ ] Memory allocation
- [ ] Print funciton in x64
- [ ] Keyboard input
- [ ] VGA-based text UI
- [ ] Basic shell
- [ ] Built-in text editor
- [ ] Math / Drawing library (+ demo programs)
- [ ] Sound output
- [ ] File system (FAT12)
- [ ] Mouse support
- [ ] Font system

## Brainstorming

- Flat memory model, identity-mapped (virtual addr = physical addr)
- Single user, kernel-only (Ring 0)
- Non premptive
- Text-based UI (Resizing available)
- Basic networking stack (IP + UDP)
- FAT12 file system
- Basic scheduler (round robin)
- Minimal memory protections
- Scripting

