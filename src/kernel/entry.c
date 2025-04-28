#include <stdint.h>
// #include <drivers/vga.h>

void kmain()
{
  // vga_init();
  // vga_set_background_color(0x00, 0x00, 0x1F);
  char *message = "Hello, World!";
  // kprint(message);
  while(1) {
    asm volatile ("hlt");
  }
}
