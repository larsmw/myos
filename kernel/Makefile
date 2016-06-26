AS=as
CC=gcc

CFLAGS=-std=gnu99 -ffreestanding -O2 -Wall -Wextra
LDFLAGS=-ffreestanding -O2 -nostdlib

VPATH = .:io

../isodir/boot/myos.bin: boot.o kernel.o io/pci.o io/ports.o
	$(CC) -T linker.ld -o $@ $(LDFLAGS) $? -lgcc

kernel.o: kernel.c
	$(CC) -c $^ -o $@ $(CFLAGS)

boot.o: boot.s
	$(AS) --64 $^ -o $@
