#include <stdint.h>
#include "drivers/vga.h"

void kmain()
{
    vga_init();
    vga_set_background_color(0x2A, 0x00, 0x2A);
    kprint("Hello, world!");
    for (;;) asm volatile("hlt");
}
