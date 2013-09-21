myos
====


This system makes use of a targeted GNU C compiler and Makefiles. You need a cross-compiler to ensure that you get the expected machine-code out into the compiled files. Here is at short guide on how to build your initial compiler : http://wiki.osdev.org/GCC_Cross-Compiler

To compile the system, adjust the path to your compiler in Makefile and type :

 make

Testing the system:

to run the system with the qemu emulator type : 

 qemu-system-x86_64 -kernel kernel/myos.bin -m 32

where 32 is the amount of megabytes of memory the virtual machine will boot with.
