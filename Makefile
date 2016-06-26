
all:
	$(MAKE) -C kernel
	grub-mkrescue -o test.iso isodir/

run:	all
	qemu-system-x86_64 -kernel kernel/myos.bin -m 32
