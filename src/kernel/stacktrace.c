#include "kernel/stacktrace.h"
#include "drivers/serial.h"
#include "kernel/types.h"

void print_stack_trace(u64 rbp_val) {
  u64 *fp = (u64 *)rbp_val;

  if (fp == 0) {
    fp = (u64 *)__builtin_frame_address(0);
  }

  serial_write_line("Stack trace:");

  for (int i = 0; i < 10; ++i) {
    u64 next_fp = fp[0];
    u64 ret_addr = fp[1];

    if (ret_addr == 0 || next_fp == 0) {
      break;
    }

    serial_write("  [");
    serial_write_hex(i);
    serial_write("] ");
    serial_write_hex(ret_addr);
    serial_write_line("");

    if (next_fp <= (u64)fp) {
      break;
    }

    fp = (u64 *)next_fp;
  }
}

