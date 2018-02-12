
	CC=clang
	CFLAGS=-fno-builtin -ffreestanding -fomit-frame-pointer -nostdlib -nodefaultlibs -O2
	CFILES=kernel/*.c kernel/*/*.c
	OBJECTS=*.o

lux32:
	fasm kernel/asm_i386/vbe.asm vbe.sys
	fasm kernel/asm_i386/bootstrap.asm bootstrap.o
	fasm kernel/asm_i386/io.asm io.o
	fasm kernel/asm_i386/state.asm state.o
	fasm kernel/asm_i386/cpu.asm cpu.o
	fasm kernel/asm_i386/sse2.asm sse2.o

	$(CC) $(CFLAGS) -target i386-elf -Ikernel/include -c $(CFILES)

	ld -melf_i386 -nostdlib -nodefaultlibs -O2 -T kernel/link.ld $(OBJECTS) -o iso/boot/kernel.sys

	grub-mkrescue -o lux.iso iso

	qemu-system-i386 -cdrom lux.iso -serial stdio -vga std -smp 2

clean:
	rm -f iso/boot/*.sys
	rm -f *.o *.sys



