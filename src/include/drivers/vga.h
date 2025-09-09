#ifndef _VGA_H_
#define _VGA_H_

#include <stdint.h>

extern volatile char *vga_ptr;
extern unsigned int cursor_offset;
extern unsigned char current_attribute;

#define VGA_WIDTH 80
#define VGA_HEIGHT 25

#define VGA_CTRL_REGISTER 0x3D4
#define VGA_DATA_REGISTER 0x3D5
#define VGA_OFFSET_LOW    0x0F
#define VGA_OFFSET_HIGH   0x0E

#define VGA_MEMORY 0xB8000
#define VGA_WHITE_ON_BLACK 0x0F

void vga_init(void);
void vga_clear(void);
void vga_set_palette_index(unsigned char index);
void vga_set_palette_color(unsigned char red, unsigned char green, unsigned char blue);
void vga_set_background_color(unsigned char red, unsigned char green, unsigned char blue);
void vga_set_char(int color, char ch, int offset);
void kprint(const char *string);
void kprint_hex(uint32_t number);
char digit_to_hex(uint8_t digit);
void vga_putchar(char ch);

#endif /* _VGA_H_ */
