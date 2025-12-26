ASM       = nasm
CC        = x86_64-elf-gcc
LD        = x86_64-elf-ld
OBJCOPY   = x86_64-elf-objcopy
QEMU      = qemu-system-x86_64
QEMU_FLAGS= -no-reboot -no-shutdown

BUILD     = build
OBJ       = obj
SRC       = .

BOOTLOADER_DIR ?= ../limine
BOOT_NAME ?= ignisos
ISO_ROOT ?= iso
ISO_FILE ?= $(BOOT_NAME).iso
KERNEL_ISO_NAME ?= kernel.elf

CFLAGS_COMMON = -Wall -Wextra -ffreestanding -fno-pic -fno-pie \
                -mno-red-zone -fno-stack-protector -nostdlib -nostartfiles \
                -mcmodel=kernel -Iinclude

CFLAGS_DEBUG = -O0 -g -fno-omit-frame-pointer
CFLAGS_BUILD ?= $(CFLAGS_DEBUG)
CFLAGS = $(CFLAGS_COMMON) $(CFLAGS_BUILD)

SRC_FILES = $(shell find $(SRC) -name '*.c')
ASM_FILES = $(shell find $(SRC) -name '*.S')

OBJ_FILES = $(SRC_FILES:%.c=$(OBJ)/%.o)
ASM_OBJ_FILES = $(ASM_FILES:%.S=$(OBJ)/%.o)
ALL_OBJ_FILES = $(OBJ_FILES) $(ASM_OBJ_FILES)

KERNEL_ELF = $(BUILD)/kernel.elf
KERNEL_BIN = $(BUILD)/kernel.bin

.PHONY: all iso run debug clean

all: $(KERNEL_ELF)

$(BUILD):
	mkdir -p $(BUILD)

$(OBJ)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ)/%.o: %.S
	@mkdir -p $(dir $@)
	$(ASM) -f elf64 $< -o $@

$(KERNEL_ELF): $(ALL_OBJ_FILES) | $(BUILD)
	$(LD) -o $@ $(ALL_OBJ_FILES) -T $(SRC)/link.ld

$(KERNEL_BIN): $(KERNEL_ELF)
	$(OBJCOPY) -O binary $< $@

iso: $(KERNEL_ELF)
	@bash ../tools/create_iso.sh \
		BOOTLOADER_DIR="$(BOOTLOADER_DIR)" \
		BOOT_NAME="$(BOOT_NAME)" \
		ISO_ROOT="$(ISO_ROOT)" \
		ISO_FILE="$(ISO_FILE)" \
		KERNEL_ISO_NAME="$(KERNEL_ISO_NAME)" \
		KERNEL_ELF="$(KERNEL_ELF)"

run: iso
	$(QEMU) -cdrom $(ISO_FILE) -m 512M $(QEMU_FLAGS) -serial stdio

debug: iso
	$(QEMU) -s -S -cdrom $(ISO_FILE) -m 512M $(QEMU_FLAGS) -serial stdio -d int,cpu_reset,guest_errors

clean:
	rm -rf $(BUILD) $(OBJ) iso_root