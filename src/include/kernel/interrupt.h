#pragma once
#include "kernel/types.h"

struct cpu_state {
  u64 rbp;
  u64 vector;
  u64 error_code;
  u64 rip;
} __attribute__((packed));

void exception_handler(struct cpu_state* state);

extern void* isr_stub_table[];