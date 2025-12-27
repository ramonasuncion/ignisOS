#pragma once

#include "kernel/types.h"

#define panic(msg) _panic(msg, __FILE__, __LINE__)

void _panic(const char *message, const char *file, u32 line);
