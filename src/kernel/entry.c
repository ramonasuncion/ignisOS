#include <drivers/vga.h>

void kmain()
{
  vga_init();
  const char str[] = "Hello from Ignis!";
  // kprint("Hello from Ignis!")
  // const char *str = "Hello from Ignis!";
  kprint(str);
  while (1);
}



