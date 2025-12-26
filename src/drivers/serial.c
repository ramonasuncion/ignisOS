#include "arch/x86_64/io.h"
#include "drivers/serial.h"

int serial_init()
{
  outb(COM1_PORT + INTERRUPT_ENABLE, 0x00); // Disable all interrupts
  outb(COM1_PORT + LINE_CONTROL, 0x80);     // Enable DLAB (set baud rate divisor)
  outb(COM1_PORT + DATA_REGISTER, 0x03);    // Set divisor to 3 (lo byte) 38400 baud
  outb(COM1_PORT + INTERRUPT_ENABLE, 0x00); //                  (hi byte)
  outb(COM1_PORT + LINE_CONTROL, 0x03);     // 8 bits, no parity, one stop bit
  outb(COM1_PORT + FIFO_CONTROL, 0xC7);     // Enable FIFO, clear them, 14-byte threshold
  outb(COM1_PORT + MODEM_CONTROL, 0x0B);    // IRQs enabled, RTS/DSR set
  outb(COM1_PORT + MODEM_CONTROL, 0x1E);    // Set in loopback mode, test serial chip
  outb(COM1_PORT + DATA_REGISTER, 0xAE);    // Test serial chip (send byte 0xAE)

  // Check if serial is faulty (i.e: not same byte as sent)
  if(inb(COM1_PORT + DATA_REGISTER) != 0xAE) {
    return 1;
  }

  // If serial is not faulty set it in normal operation mode
  // (not-loopback with IRQs enabled and OUT#1 and OUT#2 bits enabled)
  outb(COM1_PORT + MODEM_CONTROL, 0x0F);
  return 0;
}

int serial_received()
{
  return inb(COM1_PORT + LINE_STATUS) & 1;
}

int is_transmit_empty()
{
  return inb(COM1_PORT + LINE_STATUS) & 0x20;
}

void serial_write(const char *str)
{
  for (size_t i = 0; str[i]; ++i) {
    while (is_transmit_empty() == 0);
    outb(COM1_PORT, str[i]);
  }
}

char serial_read()
{
  while (serial_received() == 0);
  return inb(COM1_PORT);
}

