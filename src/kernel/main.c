#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <limine.h>

#include "kernel/boot.h"
#include "drivers/serial.h"
#include "kernel/panic.h"
#include "arch/x86_64/gdt.h"
#include "arch/x86_64/idt.h"
 
void kmain(void)
{
  serial_init();
  
  struct boot_info *info = boot_init();
  serial_write_line("Boot info parsed");

  if (info == NULL) {
    panic("Boot failed!");
  }

  gdt_init();
  serial_write_line("GDT initialized");

  idt_init();
  serial_write_line("IDT initialized");

  if (info->fb == NULL) {
    panic("No framebuffer!");
  }

  panic("Halted");
}