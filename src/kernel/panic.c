#include "kernel/panic.h"
#include "drivers/serial.h"

void __attribute__((noreturn)) _panic(const char *message, const char *file, u32 line)
{
  __asm__ volatile("cli");

  serial_write("PANIC at ");
  serial_write(file);
  serial_write(":");
  serial_write_hex(line);
  serial_write(": ");
  serial_write_line(message);

  for (;;) asm volatile("hlt");
}
