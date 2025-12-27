#pragma once
#include "kernel/types.h"

#define GDT_KERNEL_CS 0x08
#define GDT_KERNEL_DS 0x10
#define GDT_ENTRIES   3

struct gdt_entry {
  u16 limit_low;
  u16 base_low;
  u8  base_mid;
  u8  access;
  u8  granularity;
  u8  base_high;
} __attribute__((packed));

struct gdt_ptr {
  u16 limit;
  u64 base;
} __attribute__((packed));

void gdt_init(void);
