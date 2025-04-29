#!/bin/bash

nasm -f bin -o boot/boot.bin boot/stage1.asm
boot_result=$?

make
make_result=$?

echo Make Result: $make_result

if [ "$boot_result" = "0" ] && [ "$make_result" = "0" ]; then
    kernel_size=$(wc -c < build/kernel)
    kernel_sectors=$(( (kernel_size + 511) / 512 ))
    printf %02x $kernel_sectors | xxd -r -p | dd of=boot/boot.bin bs=1 seek=2 count=1 conv=notrunc

    cp boot/boot.bin ./os.img
    cat build/kernel >> os.img

    echo "Build finished successfully"
else
    result=$((boot_result + make_result))
    echo "Build failed with error code $result. See output for more info."
fi

rm -rf build obj
