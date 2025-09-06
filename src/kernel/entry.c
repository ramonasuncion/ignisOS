#include <stdint.h>
#include <drivers/vga.h>

void kmain()
{
  vga_init();
  vga_set_background_color(0x2A, 0x00, 0x2A);
  // char message[] = "Hey";
  const char *message = "Hey";
  // kprint(message);
  // kprint_hex((uintptr_t)"Hey");
  //while(1) {
  //  asm volatile ("hlt");
  //}
}

