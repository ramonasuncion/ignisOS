#!/usr/bin/env bash
set -euo pipefail

BOOTLOADER_DIR=${BOOTLOADER_DIR:-../limine}
BOOT_NAME=${BOOT_NAME:-mangoos}
ISO_ROOT=${ISO_ROOT:-iso_root}
ISO_FILE=${ISO_FILE:-${BOOT_NAME}.iso}
KERNEL_ISO_NAME=${KERNEL_ISO_NAME:-kernel.elf}
KERNEL_ELF=${KERNEL_ELF:-build/kernel.elf}

# Copy the relevant files over
rm -rf "$ISO_ROOT"
mkdir -p "$ISO_ROOT"
mkdir -p "$ISO_ROOT/boot"
cp "$KERNEL_ELF" "$ISO_ROOT/boot/"
mkdir -p "$ISO_ROOT/boot/limine"
cp "$BOOTLOADER_DIR/limine-bios.sys" "$BOOTLOADER_DIR/limine-bios-cd.bin" "$BOOTLOADER_DIR/limine-uefi-cd.bin" "$ISO_ROOT/boot/limine/"

cat > "$ISO_ROOT/boot/limine/limine.conf" <<EOF
timeout: 5

/${BOOT_NAME}
    path: boot():/boot/${KERNEL_ISO_NAME}
    protocol: limine
EOF

if command -v tr >/dev/null 2>&1; then
    tr -d '\r' < "$ISO_ROOT/boot/limine/limine.conf" > "$ISO_ROOT/boot/limine/limine.conf.tmp" && mv "$ISO_ROOT/boot/limine/limine.conf.tmp" "$ISO_ROOT/boot/limine/limine.conf"
fi

cp "$KERNEL_ELF" "$ISO_ROOT/kernel.elf" 2>/dev/null || true

# Create the EFI boot tree and copy Limine's EFI executables over
mkdir -p "$ISO_ROOT/EFI/BOOT"
cp "$BOOTLOADER_DIR/BOOTX64.EFI" "$ISO_ROOT/EFI/BOOT/"
cp "$BOOTLOADER_DIR/BOOTIA32.EFI" "$ISO_ROOT/EFI/BOOT/"

# make sure the limine tool is built for the host system
if [ ! -f "$BOOTLOADER_DIR/limine" ]; then
    echo "Limine binary not found, attempting to build..."
    make -C "$BOOTLOADER_DIR"
elif ! "$BOOTLOADER_DIR/limine" --version >/dev/null 2>&1; then
    echo "Limine binary is incompatible with this system, rebuilding..."
    make -C "$BOOTLOADER_DIR" clean
    make -C "$BOOTLOADER_DIR"
fi

# Create the bootable ISO
xorriso -as mkisofs -R -r -J -b boot/limine/limine-bios-cd.bin \
        -no-emul-boot -boot-load-size 4 -boot-info-table -hfsplus \
        -apm-block-size 2048 --efi-boot boot/limine/limine-uefi-cd.bin \
        -efi-boot-part --efi-boot-image --protective-msdos-label \
        "$ISO_ROOT" -o "$ISO_FILE"

if [ -x "$BOOTLOADER_DIR/limine" ] && [ "${SKIP_LIMINE_INSTALL:-0}" = "0" ]; then
    "$BOOTLOADER_DIR/limine" bios-install "$ISO_FILE"
fi


exit 0
