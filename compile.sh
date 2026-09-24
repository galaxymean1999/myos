rm *.bin
rm *.o
nasm -f elf32 src/boot.asm -o boot.o
nasm -f elf32 src/kernel.asm -o kernel.o

ld -m elf_i386 -T linker.ld boot.o kernel.o -o os.bin

qemu-system-x86_64 -display sdl \
	-m 256M \
       	-hda os.bin
