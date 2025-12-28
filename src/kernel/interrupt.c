#include "kernel/interrupt.h"
#include "kernel/stacktrace.h"
#include "drivers/serial.h"

static const char *exception_messages[32] = {
  "Division By Zero",
  "Debug",
  "Non-Maskable Interrupt",
  "Breakpoint",
  "Into Detected Overflow",
  "Out of Bounds",
  "Invalid Opcode",
  "No Coprocessor",
  "Double Fault",
  "Coprocessor Segment Overrun",
  "Bad TSS",
  "Segment Not Present",
  "Stack Fault",
  "General Protection Fault",
  "Page Fault",
  "Unknown Interrupt",
  "Coprocessor Fault",
  "Alignment Check",
  "Machine Check",
  "SIMD Floating-Point Exception",
  "Virtualization Exception",
  "Reserved",
  "Reserved",
  "Reserved",
  "Reserved",
  "Reserved",
  "Reserved",
  "Reserved",
  "Reserved",
  "Reserved",
  "Reserved",
  "Reserved"
};

void exception_handler(struct cpu_state *state)
{
  serial_write("EXCEPTION: ");

  if (state->vector < 32) {
    serial_write(exception_messages[state->vector]);
    serial_write(" (err ");
    serial_write_hex(state->error_code);
    serial_write(")");
  } else {
    serial_write("Unknown (vec ");
    serial_write_hex(state->vector);
    serial_write(")");
  }

  serial_write(" RIP ");
  serial_write_hex(state->rip);
  serial_write_line("");

  print_stack_trace(0);

  for (;;) {
    __asm__ volatile ("hlt");
  }
}
