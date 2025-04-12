ASM = nasm
BUILD_DIR = build
BOOT_SRC = boot.asm
BOOT_BIN = $(BUILD_DIR)/boot.bin
OS_IMAGE = $(BUILD_DIR)/os.img
QEMU = qemu-system-x86_64

all: $(OS_IMAGE)

$(BOOT_BIN): $(BOOT_SRC) | $(BUILD_DIR)
	$(ASM) -f bin $(BOOT_SRC) -o $(BOOT_BIN)

$(OS_IMAGE): $(BOOT_BIN) | $(BUILD_DIR)
	dd if=/dev/zero of=$(OS_IMAGE) bs=512 count=2880 # 1.44 MB floppy disk
	dd if=$(BOOT_BIN) of=$(OS_IMAGE) conv=notrunc

run: $(OS_IMAGE)
	$(QEMU) -drive format=raw,file=$(OS_IMAGE),if=floppy -display curses -monitor stdio -no-reboot -no-shutdown

debug: $(OS_IMAGE)
	$(QEMU) -drive format=raw,file=$(OS_IMAGE),if=floppy -monitor stdio -d int,guest_errors,cpu -no-reboot -no-shutdown

clean:
	rm -rf $(BUILD_DIR)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

.PHONY: all clean run debug
