#include <drivers/vga.h>
#include <stdint.h>

void print_string(const char* str) 
{
  int i = 0;
  while(str[i] != '\0') {
    vga_putchar(str[i]);
    i++;
  }
}

void kmain() 
{
    vga_clear();
    vga_set_background_color(0x00, 0x00, 0x1F);
      print_string("Hey!");
    while(1) {
        asm volatile ("hlt");
    }
}