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

CFLAGS    = -Wall -Wextra -m64 -mno-red-zone -ffreestanding -fno-pic -fno-pie \
						-fno-stack-protector -nostdlib -nostartfiles -mcmodel=kernel \
						-Iinclude -O0 -fno-merge-constants -fno-inline -fno-omit-frame-pointer \
						-fno-builtin -g -v

SRC_FILES = $(shell find $(SRC) -name '*.c')
OBJ_FILES = $(patsubst $(SRC)/%, $(OBJ)/%, $(SRC_FILES:.c=.o))

STAGE1_BIN= $(BUILD)/stage1.bin
STAGE2_BIN= $(BUILD)/stage2.bin
KERNEL_ELF= $(BUILD)/kernel.elf
KERNEL_BIN= $(BUILD)/kernel.bin

all: $(IMG)

$(BUILD):
	mkdir -p $(BUILD)

$(OBJ)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ)/boot/%.o: $(BOOT)/%.asm
	@mkdir -p $(dir $@)
	$(ASM) -f elf64 $< -o $@

$(KERNEL_ELF): $(OBJ_FILES) $(OBJ)/boot/entry.o
	$(LD) -o $@ $^ -T link.ld -Map=$(BUILD)/kernel.map

$(KERNEL_BIN): $(KERNEL_ELF)
	$(OBJCOPY) -O binary $< $@

$(STAGE1_BIN): $(BOOT)/stage1.asm $(BOOT)/disk.asm $(BOOT)/print.asm | $(BUILD)
	$(ASM) -I$(BOOT)/ -f bin $< -o $@

$(STAGE2_BIN): $(BOOT)/stage2.asm $(BOOT)/disk.asm $(BOOT)/print.asm | $(BUILD)
	$(ASM) -I$(BOOT)/ -f bin $< -o $@

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

