#include "kernel/interrupt.h"

void exception_handler(void)
{
  __asm__ volatile ("cli");
  for (;;) {
    __asm__ volatile ("hlt");
  }
}
