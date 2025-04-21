#ifndef _VGA_H_
#define _VGA_H_

extern volatile char *vga_ptr;
extern unsigned int cursor_offset;

void vga_init(void);
void vga_clear(void);
void vga_set_background_color(unsigned char red, unsigned char green, unsigned char blue);
void kprint(int color, const char *str);

#endif /* _VGA_H_ */
