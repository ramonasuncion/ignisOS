#include "arch/x86_64/gdt.h"

struct gdt_entry gdt[3];
struct gdt_ptr   gp;

extern void gdt_flush(void);

void gdt_set_gate(u8 num, u32 base, u32 limit, u8 access, u8 gran)
{
  gdt[num].base_low    = (base & 0xFFFF);
  gdt[num].base_mid    = (base >> 16) & 0xFF;
  gdt[num].base_high   = (base >> 24) & 0xFF;
  gdt[num].limit_low   = (limit & 0xFFFF);
  gdt[num].granularity = ((limit >> 16) & 0x0F) | (gran & 0xF0);
  gdt[num].access      = access;
}

void gdt_init(void)
{
  gp.limit = (sizeof(gdt)) - 1;
  gp.base  = (u64)&gdt;

  gdt_set_gate(0, 0, 0, 0, 0);                
  gdt_set_gate(1, 0, 0xFFFFFFFF, 0x9A, 0x20); 
  gdt_set_gate(2, 0, 0xFFFFFFFF, 0x92, 0x00); 

  gdt_flush();
}
