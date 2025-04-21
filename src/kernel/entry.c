#include <drivers/vga.h>
#include <ignis/string.h>

void kmain()
{
  vga_init();
  vga_set_background_color(0x00, 0x00, 0x1F);
  int color = 0x0F;
  const char text[] = "Hello from Ignis!";
  char buf[32];
  kprint(color, text);
  kprint(color, itoa(strlen(text), buf, 10));
  while (1);
}

