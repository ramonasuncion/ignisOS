volatile char *vga_ptr = (char*)0xB8000;
unsigned int cursor_offset = 0; /* Each character is 2 bytes. */

void kprint(const char *str)
{
  unsigned int i = 0;
  while (str[i] != '\0') {
    vga_ptr[cursor_offset] = str[i++];
    vga_ptr[cursor_offset + 1] = 0x07; /* color (int color) */
    cursor_offset += 2;
  }
}

