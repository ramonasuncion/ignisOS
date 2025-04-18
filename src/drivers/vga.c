#include <drivers/vga.h>

/*
 * TODO: Move this to header file.
 */
volatile char *vga_ptr = (char*)0xB8000;
unsigned int cursor_offset = 0; /* each cell is 2 bytes */

#define VGA_COL 80
#define VGA_ROW 25

void vga_init()
{
  vga_clear();
}

void vga_clear()
{
  for (int i = 0; i < VGA_COL * VGA_ROW; ++i)
    vga_ptr[i] = 0x0000;
}

void kprint(const char *str)
{
  unsigned int i = 0;
  while (str[i] != '\0') {
    vga_ptr[cursor_offset] = str[i];
    vga_ptr[cursor_offset + 1] = 0x07; /* color (int color) */
    cursor_offset += 2;
    i++;
  }
}

