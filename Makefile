
all:
	$(MAKE) -C kernel

run:	all
	qemu-system-x86_64 -kernel kernel/myos.bin -m 32
