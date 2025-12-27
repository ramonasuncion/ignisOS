#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <limine.h>
#include "kernel/boot.h"

#define __limine_req __attribute__((used, section(".limine_requests")))

static volatile __limine_req uint64_t limine_base_revision[] = LIMINE_BASE_REVISION(4);

static volatile __limine_req struct limine_framebuffer_request framebuffer_request = {
  .id = LIMINE_FRAMEBUFFER_REQUEST_ID,
  .revision = 0
};

static volatile __limine_req struct limine_memmap_request memmap_request = {
  .id = LIMINE_MEMMAP_REQUEST_ID,
  .revision = 0
};

__attribute__((used, section(".limine_requests_start")))
static volatile uint64_t requests_start[] = LIMINE_REQUESTS_START_MARKER;

__attribute__((used, section(".limine_requests_end")))
static volatile uint64_t requests_end[] = LIMINE_REQUESTS_END_MARKER;

static struct boot_info info;
static struct boot_framebuffer internal_fb;

static void init_framebuffer(struct limine_framebuffer *fb) {
  internal_fb = (struct boot_framebuffer){
    .address = (uint8_t *)fb->address,
    .width   = fb->width,
    .height  = fb->height,
    .pitch   = fb->pitch,
    .bpp     = fb->bpp
  };
  info.fb = &internal_fb;
}

struct boot_info *boot_init(void) {
  if (!LIMINE_BASE_REVISION_SUPPORTED(limine_base_revision) || !memmap_request.response) {
    return NULL;
  }

  info.fb = NULL;
  struct limine_framebuffer_response *fb_res = framebuffer_request.response;
  if (fb_res && fb_res->framebuffer_count > 0) {
    init_framebuffer(fb_res->framebuffers[0]);
  }

  uint64_t usable_ram = 0;
  struct limine_memmap_response *memmap = memmap_request.response;

  for (uint64_t i = 0; i < memmap->entry_count; i++) {
    struct limine_memmap_entry *entry = memmap->entries[i];
    if (entry->type == LIMINE_MEMMAP_USABLE) {
      usable_ram += entry->length;
    }
  }

  info.memory_available = usable_ram;
  return &info;
}