rm *.bin
nasm -f elf32 src/boot.asm -o boot.o
nasm -f elf32 src/load_pm.asm -o load_pm.o
nasm -f elf32 src/kernel.asm -o kernel.o
gcc -m32 -ffreestanding -fno-pie -fno-stack-protector -fno-asynchronous-unwind-tables -mno-red-zone -c src/main.c -o main.o
gcc -m32 -ffreestanding -fno-pie -fno-stack-protector -fno-asynchronous-unwind-tables -mno-red-zone -c src/drivers/screen.c -o screen.o
gcc -m32 -ffreestanding -fno-pie -fno-stack-protector -fno-asynchronous-unwind-tables -mno-red-zone -c src/drivers/port.c -o port.o
gcc -m32 -ffreestanding -fno-pie -fno-stack-protector -fno-asynchronous-unwind-tables -mno-red-zone -c src/drivers/keyboard.c -o keyboard.o
gcc -m32 -ffreestanding -fno-pie -fno-stack-protector -fno-asynchronous-unwind-tables -mno-red-zone -c src/universal/malloc.c -o malloc.o
gcc -m32 -ffreestanding -fno-pie -fno-stack-protector -fno-asynchronous-unwind-tables -mno-red-zone -c src/universal/stdio.c -o stdio.o
gcc -m32 -ffreestanding -fno-pie -fno-stack-protector -fno-asynchronous-unwind-tables -mno-red-zone -c src/cmd/commands.c -o commands.o

ld -m elf_i386 -N -T linker.ld boot.o load_pm.o kernel.o port.o keyboard.o screen.o malloc.o stdio.o commands.o main.o -o os.bin

rm *.o

qemu-system-x86_64 -display sdl \
	-m 256M \
    -hda os.bin
