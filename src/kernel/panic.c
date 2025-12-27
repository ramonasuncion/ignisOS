#include "kernel/panic.h"
#include "drivers/serial.h"
#include "arch/x86_64/io.h"

void _panic(const char *message, const char *file, u32 line)
{
    asm volatile("cli");

    serial_write("PANIC at ");
    serial_write(file);
    serial_write(":");
    serial_write_hex(line);
    serial_write(": ");
    serial_write_line(message);

    for (;;) asm volatile("hlt");
}