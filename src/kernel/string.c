#include <ignis/string.h>
#include <stddef.h>

// TODO: Move the itoa later to the lib dir.

/**
 * Convert an integer to a string
 */
char *itoa(int value, char *str, int base)
{
  char *rc;
  char *ptr;
  char *low;

  // Check for supported base
  if (base < 2 || base > 36) {
    *str = '\0';
    return str;
  }

  rc = ptr = str;

  // Set '-' for negative numbers
  if (value < 0 && base == 10) {
    *ptr++ = '-';
  }

  // Remember start position
  low = ptr;

  // Convert to absolute value for processing
  unsigned int num = (value < 0) ? -value : value;

  do {
    // Convert remainder to ASCII and store it
    int remainder = num % base;
    *ptr++ = (remainder < 10) ? remainder + '0' : remainder + 'a' - 10;
    num /= base;
  } while (num > 0);

  // Terminate the string
  *ptr = '\0';

  // Reverse the string (excluding the sign if present)
  ptr--;
  while (low < ptr) {
    char tmp = *low;
    *low++ = *ptr;
    *ptr-- = tmp;
  }

  return rc;
}

/**
 * Calculate the length of a string
 */
size_t strlen(const char *str)
{
  size_t len = 0;
  while (str[len]) {
    len++;
  }
  return len;
}
