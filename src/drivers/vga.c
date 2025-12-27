#include <stdint.h>

#include "drivers/vga.h"
#include "arch/x86_64/io.h"

volatile char *vga_ptr;
unsigned int cursor_offset = 0;
unsigned char current_attribute;

static void vga_enable_cursor(uint8_t cursor_start, uint8_t cursor_end)
{
  outb(0x3D4, 0x0A);
  outb(0x3D5, (inb(0x3D5) & 0xC0) | cursor_start);

  outb(0x3D4, 0x0B);
  outb(0x3D5, (inb(0x3D5) & 0xE0) | cursor_end);
}

static void vga_update_cursor(void)
{
  unsigned int pos = cursor_offset / 2;

  outb(0x3D4, 0x0F);
  outb(0x3D5, (uint8_t) (pos & 0xFF));
  outb(0x3D4, 0x0E);
  outb(0x3D5, (uint8_t) ((pos >> 8) & 0xFF));
}

// static uint16_t vga_get_cursor_position(void)
// {
//   uint16_t pos = 0;
//   outb(0x3D4, 0x0F);
//   pos |= inb(0x3D5);
//   outb(0x3D4, 0x0E);
//   pos |= ((uint16_t)inb(0x3D5)) << 8;
//   return pos;
// }

// static void vga_set_cursor(int offset) {
//   offset /= 2;
//   outb(VGA_CTRL_REGISTER, VGA_OFFSET_HIGH);
//   outb(VGA_DATA_REGISTER, (unsigned char) (offset >> 8));
//   outb(VGA_CTRL_REGISTER, VGA_OFFSET_LOW);
//   outb(VGA_DATA_REGISTER, (unsigned char) (offset & 0xff));
// }

// static int vga_get_cursor() {
//   outb(VGA_CTRL_REGISTER, VGA_OFFSET_HIGH);
//   int offset = inb(VGA_DATA_REGISTER) << 8;
//   outb(VGA_CTRL_REGISTER, VGA_OFFSET_LOW);
//   offset += inb(VGA_DATA_REGISTER);
//   return offset * 2;
// }

static int get_row_from_offset(int offset)
{
  return offset / (2 * VGA_WIDTH);
}

static void set_char_at_video_memory(char character, int offset)
{
  vga_ptr[offset] = character;
  vga_ptr[offset + 1] = current_attribute;
}

static int get_offset(int col, int row)
{
  return 2 * (row * VGA_WIDTH + col);
}

static int move_offset_to_new_line(int offset)
{
  return get_offset(0, get_row_from_offset(offset) + 1);
}

void vga_init(void)
{
  /* avoid relying on static initializers */
  vga_ptr = (volatile char*)VGA_MEMORY;
  current_attribute = VGA_WHITE_ON_BLACK;
  cursor_offset = 0;

  vga_clear();
  vga_enable_cursor(14, 15);
}

void vga_clear(void)
{
  for (int i = 0; i < VGA_WIDTH * VGA_HEIGHT * 2; i += 2) {
    vga_ptr[i] = ' ';
    vga_ptr[i + 1] = current_attribute;
  }
  cursor_offset = 0;
  vga_update_cursor();
}

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
  vga_set_palette_index(0x00);
  vga_set_palette_color(red, green, blue);
}

void vga_set_char(int color, char ch, int offset)
{
  vga_ptr[offset] = ch;
  vga_ptr[offset + 1] = color;
}

void kprint(const char *string)
{
  int offset = cursor_offset; // vga_get_cursor();
  int i = 0;

  while (string[i] != 0) {
    if (string[i] == '\n') {
      offset = move_offset_to_new_line(offset);
    } else {
      set_char_at_video_memory(string[i], offset);
      offset += 2;
    }
    i++;
  }

  cursor_offset = offset;
  vga_update_cursor();
}

char digit_to_hex(uint8_t digit)
{
  if (digit < 10) {
    return '0' + digit;
  } else {
    return 'A' + (digit - 10);
  }
}

void kprint_hex(uint32_t number)
{
  char buffer[11];
  buffer[0] = '0';
  buffer[1] = 'x';
  buffer[10] = '\0';

  for (int i = 9; i >= 2; i--) {
    uint8_t digit = number & 0xF;
    buffer[i] = digit_to_hex(digit);
    number >>= 4;
  }

  kprint(buffer);
}

void vga_putchar(char ch)
{
  int offset = cursor_offset; // vga_get_cursor();
  if (ch == '\n') {
    offset = move_offset_to_new_line(offset);
  } else {
    set_char_at_video_memory(ch, offset);
    offset += 2;
  }
  cursor_offset = offset;
  vga_update_cursor();
  // vga_set_cursor(offset);
}
