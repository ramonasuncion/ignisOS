ASM=nasm
LD=i686-elf-ld
ASMFLAGS=-f elf32
LDFLAGS=-T linker.ld -ffreestanding -O2
BUILD_DIR=build
BOOT_SRC=boot.asm
BOOT_OBJ=$(BUILD_DIR)/boot.o
BOOT_BIN=$(BUILD_DIR)/boot.bin

all: $(BOOT_BIN)

$(BOOT_OBJ): $(BOOT_SRC) $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) $(BOOT_SRC) -o $(BOOT_OBJ)

$(BOOT_BIN): $(BOOT_OBJ)
	$(LD) $(LDFLAGS) -o $(BOOT_BIN) $(BOOT_OBJ)

clean:
	rm -rf $(BUILD_DIR) $(BOOT_BIN)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

