#include "drivers/stdio.h"

extern char _kernel_end[];

void print_heading() {
    clear_screen();

    print_str("TinyOS V0");
    new_line();
    print_str("**********************");
    new_line();
}

void print_prompt() {
    new_line();
    print_str("> ");
}

void init() {
    void *kernel_end = (void*)_kernel_end;

    unsigned long aligned_start = ((unsigned long)kernel_end + 4095) & ~4095;

    size_t heap_size = 16 * 1024 * 1024;

    heap_init((void*)aligned_start, heap_size);

    init_keyboard();
}

void main() {
    init();

    print_heading();
	
	print_prompt();

    while (1) {
        if (get_c() == '\n') {
            print_prompt();
        }
    }
}
