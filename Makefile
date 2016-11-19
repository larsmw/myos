
.PHONY: crosscompiler

CC=gcc

crosscompiler:
	make -C $@


all: crosscompiler
	${CC} -C kernel
	grub-mkrescue -o test.iso isodir/

run: all
	qemu-system-x86_64 -kernel kernel/myos.bin -m 32
