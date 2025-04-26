// #include <stdint.h>

// // Notes for IDT setup:
// // https://wiki.osdev.org/Interrupts_Tutorial#Pre-requisites
// // https://github.com/dreamportdev/Osdev-Notes/blob/master/02_Architecture/05_InterruptHandling.md

// #define GDT_OFFSET_KERNEL_CODE 0x18

// struct idt_entry
// {
//   uint16_t isr_low;
//   uint16_t kernel_cs;
//   uint8_t  ist;
//   uint8_t  attributes;
//   uint16_t isr_mid;
//   uint32_t isr_high;
//   uint32_t reserved;
// } __attribute__((packed));

// struct idtr
// {
//   uint16_t  limit;
//   uint64_t  base;
// } __attribute__((packed));

// __attribute__((aligned(0x10)))
// struct idt_entry idt[256];

// void idt_set_descriptor(uint8_t vector, void* isr, uint8_t flags);
// void idt_set_descriptor(uint8_t vector, void* isr, uint8_t flags)
// {
//   struct idt_entry *descriptor = &idt[vector];
//   descriptor->isr_low     = (uint64_t)isr & 0xFFFF;
//   descriptor->kernel_cs   = GDT_OFFSET_KERNEL_CODE;
//   descriptor->ist         = 0;
//   descriptor->attributes  = flags;
//   descriptor->isr_mid     = ((uint64_t)isr >> 16) & 0xFFFF;
//   descriptor->isr_high    = ((uint64_t)isr >> 32) & 0xFFFFFFFF;;
//   descriptor->reserved    = 0;
// }

// void idt_init(void);
// void idt_init()
// {

// }
