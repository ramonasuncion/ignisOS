ASM = nasm
CC = x86_64-elf-gcc
LD = x86_64-elf-ld
OBJCOPY = x86_64-elf-objcopy
QEMU = qemu-system-x86_64
QEMU_FLAGS = -monitor stdio -no-reboot -no-shutdown

DEBUG = 0

CFLAGS_COMMON = -Wall -Wextra -m64 -mno-red-zone -ffreestanding -fno-pie -fno-stack-protector -nostdlib -nostartfiles -mcmodel=kernel -Iinclude
CFLAGS_DEBUG = -g -v

ifeq ($(DEBUG), 1)
	CFLAGS = $(CFLAGS_COMMON) $(CFLAGS_DEBUG)
else
	CFLAGS = $(CFLAGS_COMMON)
endif

BUILD_DIR = build
BOOT_DIR = boot
SRC_DIR = .
OBJ_DIR = obj

STAGE1_SRC = $(BOOT_DIR)/stage1.asm
STAGE2_SRC = $(BOOT_DIR)/stage2.asm
STAGE1_BIN = $(BUILD_DIR)/stage1.bin
STAGE2_BIN = $(BUILD_DIR)/stage2.bin

SRC_FILES = $(shell find . -name '*.c')
OBJ_FILES = $(patsubst ./%, $(OBJ_DIR)/%, $(SRC_FILES:.c=.o))
$(shell mkdir -p $(dir $(OBJ_FILES)))
KERNEL_ELF = $(BUILD_DIR)/kernel.elf
KERNEL_BIN = $(BUILD_DIR)/kernel.bin

OS_IMAGE = $(BUILD_DIR)/ignis.img

all: $(OS_IMAGE)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(OBJ_DIR)/%.o: %.c | $(OBJ_DIR)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/boot/entry.o: $(BOOT_DIR)/entry.asm | $(OBJ_DIR)
	@mkdir -p $(dir $@)
	$(ASM) -f elf64 $< -o $@

$(KERNEL_ELF): $(OBJ_DIR)/boot/entry.o $(OBJ_FILES) | $(BUILD_DIR)
	$(LD) -o $@ $^ -T link.ld -Map=$(BUILD_DIR)/kernel.map

$(KERNEL_BIN): $(KERNEL_ELF) | $(BUILD_DIR)
	$(OBJCOPY) -O binary $(KERNEL_ELF) $(KERNEL_BIN)

$(STAGE1_BIN): $(STAGE1_SRC) $(BOOT_DIR)/disk.asm $(BOOT_DIR)/print.asm | $(BUILD_DIR)
	$(ASM) -I$(BOOT_DIR)/ -f bin $(STAGE1_SRC) -o $(STAGE1_BIN)

$(STAGE2_BIN): $(STAGE2_SRC) $(BOOT_DIR)/disk.asm $(BOOT_DIR)/print.asm | $(BUILD_DIR)
	$(ASM) -I$(BOOT_DIR)/ -f bin $(STAGE2_SRC) -o $(STAGE2_BIN)

# 1.44 MB floppy, 18 sectors, each 512 bytes
$(OS_IMAGE): $(STAGE1_BIN) $(STAGE2_BIN) $(KERNEL_BIN) | $(BUILD_DIR)
	dd if=/dev/zero of=$(OS_IMAGE) bs=512 count=2880 # Create empty 1.44MB floppy
	dd if=$(STAGE1_BIN) of=$(OS_IMAGE) conv=notrunc # Write to sector 0
	dd if=$(STAGE2_BIN) of=$(OS_IMAGE) bs=512 seek=1 conv=notrunc # Write to sector 1
	dd if=$(BUILD_DIR)/kernel.bin of=$(OS_IMAGE) bs=512 seek=9 conv=notrunc # Write to sector 9

run: $(OS_IMAGE)
	$(QEMU) -blockdev driver=file,node-name=f0,filename=$(OS_IMAGE) -device floppy,drive=f0 $(QEMU_FLAGS)

debug: $(OS_IMAGE)
	$(QEMU) -blockdev driver=file,node-name=f0,filename=$(OS_IMAGE) -device floppy,drive=f0 $(QEMU_FLAGS) -d int,cpu_reset,guest_errors

clean:
	rm -rf $(BUILD_DIR) $(OBJ_DIR)

.PHONY: all clean run debug
