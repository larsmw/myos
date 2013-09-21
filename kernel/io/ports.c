#include "ports.h"


unsigned long inportl(unsigned short port)
{
  unsigned long result;
  __asm__ __volatile__("inl %%dx, %%eax" : "=a" (result) : "dN" (port));
  return result;
}

void outportl(unsigned short port, unsigned long data)
{
  __asm__ __volatile__("outl %%eax, %%dx" : : "d" (port), "a" (data));
}
