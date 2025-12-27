#include <stdbool.h>
#include "arch/x86_64/idt.h"
#include "arch/x86_64/gdt.h"
#include "kernel/interrupt.h"

static struct idt_entry idt[IDT_MAX_DESCRIPTORS] __attribute__((aligned(0x10)));
static struct idtr idtr;
static bool vectors[IDT_MAX_DESCRIPTORS];

extern void *isr_stub_table[];

void idt_set_descriptor(u8 vector, void *isr, u8 flags)
{
  struct idt_entry *descriptor = &idt[vector];

  descriptor->isr_low = (u64)isr & 0xFFFF;
  descriptor->kernel_cs = GDT_KERNEL_CS;
  descriptor->ist = 0;
  descriptor->attributes = flags;
  descriptor->isr_mid = ((u64)isr >> 16) & 0xFFFF;
  descriptor->isr_high = ((u64)isr >> 32) & 0xFFFFFFFF;
  descriptor->reserved = 0;
}

void idt_init(void)
{
  idtr.base = (uintptr_t)&idt[0];
  idtr.limit = (u16)(sizeof(struct idt_entry) * IDT_MAX_DESCRIPTORS) - 1;

  for (u8 vector = 0; vector < 32; vector++) {
    idt_set_descriptor(vector, isr_stub_table[vector], 0x8E);
    vectors[vector] = true;
  }

  __asm__ volatile("lidt %0" : : "m"(idtr));
  __asm__ volatile("sti");
}
