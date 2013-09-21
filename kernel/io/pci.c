#include "pci.h"
#include "ports.h"

unsigned short pciConfigReadWord (unsigned short bus, unsigned short slot,
  unsigned short func, unsigned short offset)
{
  unsigned long address;
  unsigned long lbus = (unsigned long)bus;
  unsigned long lslot = (unsigned long)slot;
  unsigned long lfunc = (unsigned long)func;
  unsigned short tmp = 0;
  
  /* create configuration address as per Figure 1 */
  address = (unsigned long)((lbus << 16) | (lslot << 11) |
	    (lfunc << 8) | (offset & 0xfc) | ((UINT32)0x80000000));
  
  /* write out the address */
  outportl (0xCF8, address);
  /* read in the data */
  /* (offset & 2) * 8) = 0 will choose the fisrt word of the 32 bits register */
  tmp = (unsigned short)((inportl (0xCFC) >> ((offset & 2) * 8)) & 0xffff);
  return (tmp);
}

unsigned short pciCheckVendor(unsigned short bus, unsigned short slot)
{
  unsigned short vendor,device;
  /* try and read the first configuration register. Since there are no */
  /* vendors that == 0xFFFF, it must be a non-existent device. */
  if ((vendor = pciConfigReadWord(bus,slot,0,0)) != 0x0300) {
    device = pciConfigReadWord(bus,slot,0,2);
  } return (vendor);
}
