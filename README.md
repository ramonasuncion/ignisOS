# IgnisOS

A hobby osdev project. I intend to develop a x64 monolithic OS.

## Demo

![OS](./os_demo.png)

## Dependencies

You will need the following tools:

- **Compiler**: `x86_64-elf-gcc` (cross-compiler for bare-metal x86_64)
- **Assembler**: `nasm`
- **Linker**: `x86_64-elf-ld` (part of cross-compiler)
- **Emulator**: `qemu-system-x86_64`

## Installation

### Ubuntu/Debian

```bash
sudo apt update
sudo apt install -y gcc-x86-64-linux-gnu binutils-x86-64-linux-gnu nasm qemu-system-x86-64 xorriso make
```

Create symlinks for x86_64-elf tools:

```bash
sudo ln -s /usr/bin/x86_64-linux-gnu-gcc /usr/local/bin/x86_64-elf-gcc
sudo ln -s /usr/bin/x86_64-linux-gnu-ld /usr/local/bin/x86_64-elf-ld
sudo ln -s /usr/bin/x86_64-linux-gnu-objcopy /usr/local/bin/x86_64-elf-objcopy
```

### macOS (Homebrew)

```bash
brew install x86_64-elf-gcc x86_64-elf-binutils nasm qemu xorriso make
```

### Docker (Alternative)

If you don't want to install cross-compilers locally, you can build using Docker:

```bash
./tools/run-docker-build.sh
```

## Limine Bootloader

IgnisOS uses the [Limine boot protocol](https://codeberg.org/Limine/limine-protocol).

### Download Limine

```bash
git clone --branch=v10.x-binary --depth=1 https://github.com/limine-bootloader/limine.git limine
```

The `limine/` directory is excluded from git (see `.gitignore`).

## Building

Navigate to the `src/` directory to build:

```bash
cd src
make all       # Build kernel (creates build/kernel.elf)
make clean     # Clean build artifacts
make iso       # Create bootable ISO image
make run       # Build and run in QEMU
make debug     # Build and run with GDB debugging
```

## Debugging

### Using GDB

In one terminal:

```bash
cd src
make debug
```

In another terminal:

```bash
x86_64-elf-gdb build/kernel.elf
(gdb) target remote :1234
```

### Debugging Tools

- `gdb` - GNU Debugger
- `objdump` - Display object file information
- `readelf` - Display ELF file information
- `hexdump` - View binary data

## Resources

- [OSDev - GCC Cross Compiler](https://wiki.osdev.org/GCC_Cross-Compiler)
- [Limine Protocol](https://codeberg.org/Limine/limine-protocol)
- [Limine Repository](https://codeberg.org/Limine/Limine)
- [Debian - QEMU](https://wiki.debian.org/QEMU)

## Contributing

I welcome contributions to this project. Please read [CONTRIBUTING.md](./CONTRIBUTING.md).

## Reading List

1. Operating Systems: Design and Implementation (Second Edition).
   by Andrew S. Tanenbaum (Author), Albert S. Woodhull (Author) - Thanks to Professor Xiannong Meng at Bucknell University.
2. Operating System Concepts, 5th Edition
   by Abraham Silberschatz (Author), Baer Galvin (Author), Peter Gagne (Author) - Thanks to Professor Jessen Havill at Bucknell Univerisity.
