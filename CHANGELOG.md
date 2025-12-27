# Changelog

## 0.1.0 (April 21, 2025)

- Support 64-bit x86 CPU architecture
- Basic kernel to print 'Hello from Mango'
- Two-stage bootloader:
  - Stage 1 (512 bytes): Enables A20 gate, loads stage 2 from disk
  - Stage 2: Sets up protected mode, paging, and transitions to long mode
  - Loads kernel from disk to 1MB memory location
- Added color palette manipulation functions
- Implemented cursor positioning and movement
- Simple VGA text mode driver with background color support
- Basic string handling utilities (strlen, itoa)

## 0.0.0 (Apr 10, 2025)

- I spent a couple of days planning what the operating system (OS) will look like. A common beginner mistake is getting stuck on which direction the OS should take.
