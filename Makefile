
all:
	$(MAKE) -C kernel

run:
	qemu-system-x86_64 -kernel kernel/myos.bin -m 32
