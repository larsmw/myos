AS=~/opt/cross/bin/i586-elf-as
CC=~/opt/cross/bin/i586-elf-gcc

CFLAGS=-std=gnu99 -ffreestanding -O2 -Wall -Wextra
LDFLAGS=-ffreestanding -O2 -nostdlib

myos.bin: boot.o kernel.o
	$(CC) -T linker.ld -o $@ $(LDFLAGS) $? -lgcc

kernel.o: kernel.c
	$(CC) -c $^ -o $@ $(CFLAGS)

boot.o: boot.s
	$(AS) $^ -o $@
