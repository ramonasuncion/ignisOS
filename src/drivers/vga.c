//#include <drivers/vga.h>
//#include <stdint.h>
//#include <arch/x86_64/io.h>
//
//volatile char *vga_ptr = (char*)0xB8000;
//unsigned int cursor_offset = 0; /* each cell is 2 bytes */
//
//#define VGA_COL 80
//#define VGA_ROW 25
//
//#define VGA_CTRL_REGISTER 0x3D4
//#define VGA_DATA_REGISTER 0x3D5
//#define VGA_OFFSET_LOW    0x0F
//#define VGA_OFFSET_HIGH   0x0E
//
////static void vga_enable_cursor(uint8_t cursor_start, uint8_t cursor_end)
////{
////  outb(0x3D4, 0x0A);
////  outb(0x3D5, (inb(0x3D5) & 0xC0) | cursor_start);
////
////  outb(0x3D4, 0x0B);
////  outb(0x3D5, (inb(0x3D5) & 0xE0) | cursor_end);
////}
//
//// https://wiki.osdev.org/Text_Mode_Cursor#Moving_the_Cursor
//// these are different: https://dev.to/frosnerd/writing-my-own-vga-driver-22nn
//static void vga_update_cursor(void)
//{
//  unsigned int pos = cursor_offset / 2;
//
//  outb(0x3D4, 0x0F);
//  outb(0x3D5, (uint8_t) (pos & 0xFF));
//  outb(0x3D4, 0x0E);
//  outb(0x3D5, (uint8_t) ((pos >> 8) & 0xFF));
//}
//
////static uint16_t vga_get_cursor_position(void)
////{
////  uint16_t pos = 0;
////  outb(0x3D4, 0x0F);
////  pos |= inb(0x3D5);
////  outb(0x3D4, 0x0E);
////  pos |= ((uint16_t)inb(0x3D5)) << 8;
////  return pos;
////}
//
//void vga_init()
//{
//  vga_clear();
//  // vga_enable_cursor();
//}
//
//void vga_clear()
//{
//  for (int i = 0; i < VGA_COL * VGA_ROW * 2; i += 2) {
//    vga_ptr[i] = ' ';
//    vga_ptr[i + 1] = 0x07;
//  }
//  cursor_offset = 0;
//  vga_update_cursor();
//}
//
//// https://wiki.osdev.org/VGA_Hardware
//void vga_set_palette_index(unsigned char index)
//{
//  outb(0x3C8, index);
//}
//
//void vga_set_palette_color(unsigned char red, unsigned char green, unsigned char blue)
//{
//  outb(0x3C9, red);
//  outb(0x3C9, green);
//  outb(0x3C9, blue);
//}
//
//void vga_set_background_color(unsigned char red, unsigned char green, unsigned char blue)
//{
//  vga_set_palette_index(0x00); // index 0 for background color
//  vga_set_palette_color(red, green, blue);
//}
//
//void vga_set_char(int color, char ch, int offset)
//{
//  vga_ptr[offset] = ch;
//  vga_ptr[offset + 1] = color;
//}
//
//// Read more: https://wiki.osdev.org/Printing_To_Screen
//// This is relatively horrible - reading from VGA memory is slow (better to have a buffer in RAM), and it means there's no way to see any text that disappeared off the top of the screen ever again.
//// https://stackoverflow.com/questions/71964436/how-to-write-a-newline-in-vga-memory
////  One way to fix these problems is to append the new string to a kernel log in memory, and then display the last (up to) VGA_HEIGHT lines from the log; so that the whole log can be viewed (and/or written to disk) later. That creates the possibility of replacing the slow memmove() with a faster "print everything from the log in memory again, starting from an updated top of screen pointer" approach. (add the memmove to string.h)
////void kprint(const char *str) // int color,
////{
////  while (*str != 0) {
////    //    if (*str == '\n') {
////    //      cursor_offset = (cursor_offset / VGA_COL + 1) * VGA_COL;
////    //    } else {
////    vga_ptr[cursor_offset] = *str;
////    vga_ptr[cursor_offset + 1] = 0x0f; // color;
////    cursor_offset += 2;
////    //    }
////    str++;
////  }
////  vga_update_cursor();
////}
//
//void set_cursor(int offset) {
//    offset /= 2;
//    outb(VGA_CTRL_REGISTER, VGA_OFFSET_HIGH);
//    outb(VGA_DATA_REGISTER, (unsigned char) (offset >> 8));
//    outb(VGA_CTRL_REGISTER, VGA_OFFSET_LOW);
//    outb(VGA_DATA_REGISTER, (unsigned char) (offset & 0xff));
//}
//
//int get_cursor() {
//    outb(VGA_CTRL_REGISTER, VGA_OFFSET_HIGH);
//    int offset = inb(VGA_DATA_REGISTER) << 8;
//    outb(VGA_CTRL_REGISTER, VGA_OFFSET_LOW);
//    offset += inb(VGA_DATA_REGISTER);
//    return offset * 2;
//}
//
//#define VIDEO_ADDRESS 0xb8000
//#define MAX_ROWS 25
//#define MAX_COLS 80
//#define WHITE_ON_BLACK 0x0f
//
//void set_char_at_video_memory(char character, int offset) {
//  unsigned char *vidmem = (unsigned char *) VIDEO_ADDRESS;
//  vidmem[offset] = character;
//  vidmem[offset + 1] = WHITE_ON_BLACK;
//}
//
//int get_row_from_offset(int offset) {
//  return offset / (2 * MAX_COLS);
//}
//
//int get_offset(int col, int row) {
//  return 2 * (row * MAX_COLS + col);
//}
//
//int move_offset_to_new_line(int offset) {
//  return get_offset(0, get_row_from_offset(offset) + 1);
//}
//
//void kprint(const char *string) {
//  int offset = get_cursor();
//  int i = 0;
//  while (string[i] != 0) {
//    if (string[i] == '\n') {
//      offset = move_offset_to_new_line(offset);
//    } else {
//      set_char_at_video_memory(string[i], offset);
//      offset += 2;
//    }
//    i++;
//  }
//  set_cursor(offset);
//}
//
//// char digit_to_hex(uint8_t digit) {
////     if (digit < 10) {
////         return '0' + digit;
////     } else {
////         return 'A' + (digit - 10);
////     }
//// }
//
//// void kprint_hex(uint32_t number) {
////     char buffer[11]; // "0x" prefix + 8 hex digits + null terminator
////     buffer[0] = '0';
////     buffer[1] = 'x';
////     buffer[10] = '\0';
//
////     // Fill the buffer from right to left
////     for (int i = 9; i >= 2; i--) {
////         uint8_t digit = number & 0xF;
////         buffer[i] = digit_to_hex(digit);
////         number >>= 4;
////     }
//
////     kprint(buffer);
//// }
