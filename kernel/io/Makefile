AS=~/opt/cross/bin/i586-elf-as
CC=~/opt/cross/bin/i586-elf-gcc

CFLAGS=-std=gnu99 -ffreestanding -O2 -Wall -Wextra
LDFLAGS=-ffreestanding -O2 -nostdlib

pci.o: pci.c ports.c
	$(CC) -c $^ $(CFLAGS)

