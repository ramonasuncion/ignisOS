ASM = nasm
BUILD_DIR = build
UNAME := $(shell uname)
SRC_DIR = .

STAGE1_SRC = stage1.asm
STAGE2_SRC = stage2.asm

STAGE1_BIN = $(BUILD_DIR)/stage1.bin
STAGE2_BIN = $(BUILD_DIR)/stage2.bin
OS_IMAGE = $(BUILD_DIR)/os.img

CC = x86_64-elf-gcc
LD = x86_64-elf-ld

ifeq ($(UNAME), Linux)
	CC = gcc
	LD = ld
endif

CFLAGS = -v -m64 -ffreestanding -fno-pie -fno-stack-protector -nostdlib -nostartfiles
KERNEL_OBJ = $(BUILD_DIR)/kernel.o

QEMU = qemu-system-x86_64
QEMU_FLAGS = -monitor stdio -no-reboot -no-shutdown

all: $(OS_IMAGE)

$(KERNEL_OBJ): kernel.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c kernel.c -o $(KERNEL_OBJ)

$(BUILD_DIR)/kernel.bin: $(KERNEL_OBJ) | $(BUILD_DIR)
	$(LD) -o $@ $< -T link.ld

$(STAGE1_BIN): $(STAGE1_SRC) disk.asm print.asm | $(BUILD_DIR)
	$(ASM) -f bin $(STAGE1_SRC) -o $(STAGE1_BIN)

$(STAGE2_BIN): $(STAGE2_SRC) disk.asm print.asm | $(BUILD_DIR)
	$(ASM) -f bin $(STAGE2_SRC) -o $(STAGE2_BIN)

$(OS_IMAGE): $(STAGE1_BIN) $(STAGE2_BIN) $(BUILD_DIR)/kernel.bin | $(BUILD_DIR)
	dd if=/dev/zero of=$(OS_IMAGE) bs=512 count=2880
	dd if=$(STAGE1_BIN) of=$(OS_IMAGE) conv=notrunc
	dd if=$(STAGE2_BIN) of=$(OS_IMAGE) bs=512 seek=1 conv=notrunc
	dd if=$(BUILD_DIR)/kernel.bin of=$(OS_IMAGE) bs=512 seek=9 conv=notrunc

run: $(OS_IMAGE)
	$(QEMU) -drive format=raw,file=$(OS_IMAGE),if=floppy $(QEMU_FLAGS)

debug: $(OS_IMAGE)
	$(QEMU) -drive format=raw,file=$(OS_IMAGE),if=floppy $(QEMU_FLAGS) -d int,cpu_reset,guest_errors

clean:
	rm -rf $(BUILD_DIR)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

.PHONY: all clean run debug
