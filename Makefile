ASM = nasm
BUILD_DIR = build
BOOT_SRC = boot.asm
BOOT_BIN = $(BUILD_DIR)/boot.bin

all: $(BOOT_BIN)

$(BOOT_BIN): $(BOOT_SRC) | $(BUILD_DIR)
	$(ASM) -f bin $(BOOT_SRC) -o $(BOOT_BIN)

clean:
	rm -rf $(BUILD_DIR)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)
