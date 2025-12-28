#pragma once

#include <stdint.h>

struct boot_framebuffer {
  uint8_t *address;
  uint64_t width;
  uint64_t height;
  uint64_t pitch;
  uint16_t bpp;
};

struct boot_info {
  struct boot_framebuffer *fb;
  uint64_t memory_available;
};

struct boot_info *boot_init(void);
