#pragma once

#include <stdint.h>
#include <stddef.h>

#define COM1_PORT 0x3F8

// Register offsets
#define DATA_REGISTER       0   // Data Register (read/write)
#define INTERRUPT_ENABLE    1   // Interrupt Enable Register (write)
#define FIFO_CONTROL        2   // FIFO Control Register (write)
#define LINE_CONTROL        3   // Line Control Register (write)
#define MODEM_CONTROL       4   // Modem Control Register (write)
#define LINE_STATUS         5   // Line Status Register (read)
#define MODEM_STATUS        6   // Modem Status Register (read)
#define SCRATCH_REGISTER    7   // Scratch Register (read/write)

// Line Status Register bits
#define LSR_DR      (1 << 0) // Data Ready
#define LSR_THRE    (1 << 5) // Transmit Holding Register Empty

int serial_init(void);
void serial_write(const char *str);