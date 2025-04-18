ASM = nasm
BUILD_DIR = build
BOOT_DIR = boot
SRC_DIR = .

STAGE1_SRC = $(BOOT_DIR)/stage1.asm
STAGE2_SRC = $(BOOT_DIR)/stage2.asm

STAGE1_BIN = $(BUILD_DIR)/stage1.bin
STAGE2_BIN = $(BUILD_DIR)/stage2.bin
OS_IMAGE = $(BUILD_DIR)/ignis.img

CC = x86_64-elf-gcc
LD = x86_64-elf-ld
OBJCOPY = x86_64-elf-objcopy

CFLAGS = -v -Wall -Wextra -m64 -mno-red-zone -ffreestanding -fno-pie -fno-stack-protector -nostdlib -nostartfiles -g # -mcmodel=kernel
SRC_FILES = $(wildcard $(SRC_DIR)/*.c)
KERNEL_OBJ = $(BUILD_DIR)/kernel.o

QEMU = qemu-system-x86_64
QEMU_FLAGS = -monitor stdio -no-reboot -no-shutdown

all: $(OS_IMAGE)

$(BUILD_DIR)/kernel.bin: $(SRC_FILES) | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $(SRC_FILES) -o $(BUILD_DIR)/kernel.o
	$(LD) -o $@ $(BUILD_DIR)/kernel.o -T link.ld
	$(OBJCOPY) -O binary $@ $(BUILD_DIR)/kernel.bin

$(STAGE1_BIN): $(STAGE1_SRC) $(BOOT_DIR)/disk.asm $(BOOT_DIR)/print.asm | $(BUILD_DIR)
	$(ASM) -I$(BOOT_DIR)/ -f bin $(STAGE1_SRC) -o $(STAGE1_BIN)

$(STAGE2_BIN): $(STAGE2_SRC) $(BOOT_DIR)/disk.asm $(BOOT_DIR)/print.asm | $(BUILD_DIR)
	$(ASM) -I$(BOOT_DIR)/ -f bin $(STAGE2_SRC) -o $(STAGE2_BIN)

# 1.44 MB floppy, 18 sectors, each 512 bytes
$(OS_IMAGE): $(STAGE1_BIN) $(STAGE2_BIN) $(BUILD_DIR)/kernel.bin | $(BUILD_DIR)
	dd if=/dev/zero of=$(OS_IMAGE) bs=512 count=2880 # Create empty 1.44MB floppy
	dd if=$(STAGE1_BIN) of=$(OS_IMAGE) conv=notrunc # Write to sector 0
	dd if=$(STAGE2_BIN) of=$(OS_IMAGE) bs=512 seek=1 conv=notrunc # Write to sector 1
	dd if=$(BUILD_DIR)/kernel.bin of=$(OS_IMAGE) bs=512 seek=9 conv=notrunc # Write to sector 9

run: $(OS_IMAGE)
	$(QEMU) -drive format=raw,file=$(OS_IMAGE),if=floppy $(QEMU_FLAGS)

debug: $(OS_IMAGE)
	$(QEMU) -drive format=raw,file=$(OS_IMAGE),if=floppy $(QEMU_FLAGS) -d int,cpu_reset,guest_errors

clean:
	rm -rf $(BUILD_DIR)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

.PHONY: all clean run debug
