#include "ports.h"


unsigned short pciConfigReadWord (unsigned short bus, unsigned short slot,
  unsigned short func, unsigned short offset);
unsigned short pciCheckVendor(unsigned short bus, unsigned short slot);

