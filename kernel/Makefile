AS=~/opt/cross/bin/i586-elf-as
CC=~/opt/cross/bin/i586-elf-gcc

CFLAGS=-std=gnu99 -ffreestanding -O2 -Wall -Wextra
LDFLAGS=-ffreestanding -O2 -nostdlib

VPATH = .:io

myos.bin: boot.o kernel.o io/pci.o io/ports.o
	$(CC) -T linker.ld -o $@ $(LDFLAGS) $? -lgcc

kernel.o: kernel.c
	$(CC) -c $^ -o $@ $(CFLAGS)

boot.o: boot.s
	$(AS) $^ -o $@
