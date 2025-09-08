ASM       = nasm
CC        = x86_64-elf-gcc
LD        = x86_64-elf-ld
OBJCOPY   = x86_64-elf-objcopy
QEMU      = qemu-system-x86_64
QEMU_FLAGS= -monitor stdio -no-reboot -no-shutdown

BUILD     = build
OBJ       = obj
BOOT      = boot
SRC       = .
IMG       = $(BUILD)/ignis.img

CFLAGS_COMMON = -Wall -Wextra -ffreestanding -fno-pic -fno-pie \
								-mno-red-zone -fno-stack-protector -nostdlib -nostartfiles \
								-mcmodel=kernel -Iinclude

CFLAGS_DEBUG = -O0 -g -fno-omit-frame-pointer

# Select build type flags (default DEBUG)
# TODO: Create a make release.
CFLAGS_BUILD ?= $(CFLAGS_DEBUG)

CFLAGS = $(CFLAGS_COMMON) $(CFLAGS_BUILD)

SRC_FILES = $(shell find $(SRC) -name '*.c')
OBJ_FILES = $(patsubst $(SRC)/%, $(OBJ)/%, $(SRC_FILES:.c=.o))

STAGE1_BIN= $(BUILD)/stage1.bin
STAGE2_BIN= $(BUILD)/stage2.bin
KERNEL_ELF= $(BUILD)/kernel.elf
KERNEL_BIN= $(BUILD)/kernel.bin

UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Linux)
    STAT_CMD = stat -c%s
else ifeq ($(UNAME_S),Darwin)
    STAT_CMD = stat -f%z
endif

KERNEL_SIZE_BYTES = $(shell $(STAT_CMD) $(KERNEL_BIN))
KERNEL_SECTORS = $(shell printf "%d" $$(( ( $(KERNEL_SIZE_BYTES) + 511 ) / 512 + 1)))

all: $(IMG)

$(BUILD):
	mkdir -p $(BUILD)

$(OBJ)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ)/boot/%.o: $(BOOT)/%.asm
	@mkdir -p $(dir $@)
	$(ASM) -f elf64 $< -o $@ # -l build/stage2.lst

$(KERNEL_ELF):  $(OBJ)/boot/entry.o $(OBJ_FILES) # obj/kernel/entry.o obj/boot/entry.o
	$(LD) -o $@ $^ -T $(SRC)/link.ld -Map=$(BUILD)/kernel.map

$(KERNEL_BIN): $(KERNEL_ELF)
	$(OBJCOPY) -O binary $< $@

$(STAGE1_BIN): $(BOOT)/stage1.asm $(BOOT)/disk.asm $(BOOT)/print.asm | $(BUILD)
	$(ASM) -I$(BOOT)/ -f bin $< -o $@

$(STAGE2_BIN): $(BOOT)/stage2.asm $(BOOT)/disk.asm $(BOOT)/print.asm $(KERNEL_BIN) | $(BUILD)
	@echo "Using the $(UNAME_S) stat command"
	@echo "Kernel size: $(KERNEL_SIZE_BYTES) bytes ($(KERNEL_SECTORS) sectors)"
	$(ASM) -I$(BOOT)/ -D KERNEL_SECTORS=$(KERNEL_SECTORS) -f bin $(BOOT)/stage2.asm -o $@

$(IMG): $(STAGE1_BIN) $(STAGE2_BIN) $(KERNEL_BIN)
	dd if=/dev/zero of=$@ bs=512 count=2880
	dd if=$(STAGE1_BIN) of=$@ conv=notrunc
	dd if=$(STAGE2_BIN) of=$@ bs=512 seek=1 conv=notrunc
	dd if=$(KERNEL_BIN) of=$@ bs=512 seek=9 conv=notrunc

run: $(IMG)
	$(QEMU) -blockdev driver=file,node-name=f0,filename=$< -device floppy,drive=f0 $(QEMU_FLAGS)

debug: $(IMG)
	$(QEMU) -s -S -blockdev driver=file,node-name=f0,filename=$< -device floppy,drive=f0 $(QEMU_FLAGS) -d int,cpu_reset,guest_errors

clean:
	rm -rf $(BUILD) $(OBJ)

.PHONY: all run debug clean

