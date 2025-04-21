#include <drivers/vga.h>
#include <stdint.h>
#include <arch/x86_64/io.h>

/*
 * TODO: Move this to header file.
 */
volatile char *vga_ptr = (char*)0xB8000;
unsigned int cursor_offset = 0; /* each cell is 2 bytes */

#define VGA_COL 80
#define VGA_ROW 25

// https://wiki.osdev.org/Text_Mode_Cursor#Moving_the_Cursor

static void vga_update_cursor(void)
{
  unsigned int pos = cursor_offset / 2;

  outb(0x3D4, 0x0F);
  outb(0x3D5, (uint8_t) (pos & 0xFF));
  outb(0x3D4, 0x0E);
  outb(0x3D5, (uint8_t) ((pos >> 8) & 0xFF));
}

void vga_init()
{
  vga_clear();
}

void vga_clear()
{
  for (int i = 0; i < VGA_COL * VGA_ROW * 2; i += 2) {
    vga_ptr[i] = ' ';
    vga_ptr[i + 1] = 0x07;
  }
  cursor_offset = 0;
  vga_update_cursor();
}


// https://wiki.osdev.org/VGA_Hardware
void vga_set_palette_index(unsigned char index)
{
  outb(0x3C8, index);
}

void vga_set_palette_color(unsigned char red, unsigned char green, unsigned char blue)
{
  outb(0x3C9, red);
  outb(0x3C9, green);
  outb(0x3C9, blue);
}

void vga_set_background_color(unsigned char red, unsigned char green, unsigned char blue)
{
  vga_set_palette_index(0x00); // index 0 for background color
  vga_set_palette_color(red, green, blue);
}

// Read more: https://wiki.osdev.org/Printing_To_Screen
void kprint(int color, const char *str)
{
  while (*str != 0) {
    vga_ptr[cursor_offset] = *str++;
    vga_ptr[cursor_offset + 1] = color;
    cursor_offset += 2;
  }

  vga_update_cursor();
}
