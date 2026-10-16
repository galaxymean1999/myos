#include "drivers/screen.h"
#include "drivers/keyboard.h"

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

void main() {
    print_heading();
	
	print_prompt();

    while (1) {
        char c = 0;
        if (key_available()) {
            c = get_key_ascii();
        }
		
		if (c == '\n') {
			new_line();
			print_prompt();
		}
		else if (c == '\b') {
			put_char(get_cursor_x() - 1, get_cursor_y(), ' ', 0x0f);
			set_cursor_position(get_cursor_x() - 2, get_cursor_y());
		}
        else if (c != 0) {
            put_char(get_cursor_x(), get_cursor_y(), c, 0x0f);
        }
    }
}
