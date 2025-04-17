#include <stdint.h>

// https://github.com/dreamportdev/Osdev-Notes/blob/master/02_Architecture/05_InterruptHandling.md
// https://forum.osdev.org/download/file.php?id=3406
// https://wiki.osdev.org/What_Order_Should_I_Make_Things_In%3F
// https://wiki.osdev.org/Interrupt_Descriptor_Table#Structure_on_x86-64
// https://wiki.osdev.org/Interrupts_Tutorial#Pre-requisites
// https://wiki.osdev.org/Interrupt_Descriptor_Table#Structure_on_x86-64

struct interrupt_descriptor
{
  uint16_t    isr_low;
  uint16_t    kernel_cs;
  uint8_t     ist;
  uint8_t     attributes;
  uint16_t    isr_mid;
  uint32_t    isr_high;
  uint32_t    reserved;
} __attribute__((packed));

void init_idt()
{
}

void kmain()
{


  while (1) {
    __asm__ volatile("hlt");
  }
}
