myos
====


This system makes use of a targeted GNU c compiler and Makefiles.
To compile the system type :

 make

to run the system with qemu type : 

 qemu-system-x86_64 -kernel kernel/myos.bin -m 32
