#pragma once

#include "kernel/types.h"

#define IDT_MAX_DESCRIPTORS 256

struct idt_entry {
  u16 isr_low;
  u16 kernel_cs;
  u8  ist;
  u8  attributes;
  u16 isr_mid;
  u32 isr_high;
  u32 reserved;
} __attribute__((packed));

struct idtr {
  u16 limit;
  u64 base;
} __attribute__((packed));

void idt_init(void);
