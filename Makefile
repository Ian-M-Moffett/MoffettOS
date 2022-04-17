all: src/asm/multiboot_header.asm src/asm/boot.asm 
	xargo build --release --target=x86_64-unknown-moffett_os-gnu
	nasm -felf64 src/asm/multiboot_header.asm
	nasm -felf64 src/asm/boot.asm
	mkdir -p bin
	ld --nmagic --output=bin/kernel.bin -Tsrc/asm/link.ld src/asm/*.o target/x86_64-unknown-moffett_os-gnu/release/libmoffett_os.a
	rm src/asm/*.o
	mv bin/* src/asm/MoffettOS/boot/
	grub-mkrescue -o MoffettOS.iso src/asm/MoffettOS
	xargo build --release --target=x86_64-unknown-moffett_os-gnu

run:
	qemu-system-x86_64 -cdrom MoffettOS.iso -monitor stdio

clean:
	cargo clean
