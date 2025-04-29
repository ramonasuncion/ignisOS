#include <stdint.h>
#include <drivers/vga.h>

void kmain()
{
  vga_init();
  vga_set_background_color(0x2A, 0x00, 0x2A);
  char *message = "Hello, World!";
  // static const char message[] = "Hello, World!";
  kprint(message);
  // kprint("Hello, World!");
  while(1) {
    asm volatile ("hlt");
  }
}
