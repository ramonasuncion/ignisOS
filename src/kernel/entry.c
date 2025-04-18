// #include <drivers/vga.h>

void kmain()
{
  volatile char *vga_ptr = (char*)0xB8000;
  vga_ptr[0] = 'O';
  vga_ptr[1] = 0x0A;
  vga_ptr[2] = 'K';
  vga_ptr[3] = 0x0A;

  // kprint("Hello from Ignis!");
  for (;;) __asm__ volatile("hlt");
}



