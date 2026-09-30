rm *.bin
rm *.o
nasm -f elf32 src/boot.asm -o boot.o
nasm -f elf32 src/load_pm.asm -o load_pm.o
nasm -f elf32 src/kernel.asm -o kernel.o
nasm -f elf32 src/drivers/screen.asm -o screen.o

ld -m elf_i386 -T linker.ld boot.o load_pm.o kernel.o screen.o -o os.bin

qemu-system-x86_64 -display sdl \
	-m 256M \
    -hda os.bin
