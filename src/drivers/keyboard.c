#include "keyboard.h"
#include "screen.h"

#include "../cmd/commands.h"

unsigned char key_available() {
    return in(KEYBOARD_STATUS_PORT) & 1;
}

char get_key_ascii() {
    u8 scan_code = in(KEYBOARD_DATA_PORT);

    if (scan_code & 0x80) {
        return 0;
    }

    if (scan_code < sizeof(scan_code_table)) {
        return scan_code_table[scan_code];
    }

    return 0;
}

char get_c() {

    while (!key_available()) { }
    
    char c = 0;

    c = get_key_ascii();

    if (c == '\n') {
        c_buff[current_c] = 0;

        new_line();
        fetch_command(c_buff);
        new_line();

        clear_buff();
    }
    else if (c == '\b') {
        if (get_cursor_x() > 2) {
            put_char(get_cursor_x() - 1, get_cursor_y(), ' ', 0x0f);
            set_cursor_position(get_cursor_x() - 2, get_cursor_y());

            current_c--;
            c_buff[current_c] = 0;
        }
    }
    else if (c != 0) {
        put_char(get_cursor_x(), get_cursor_y(), c, 0x0f);
        
        c_buff[current_c] = c;

        if (current_c < 128) {
            current_c++;
        }
    }

    return c;
}

void clear_buff() {
    for (int i = 0; i < c_buff_len; i++) {
        c_buff[i] = 0;
    }

    current_c = 0;
}

void init_keyboard() {
    c_buff = mem_alloc(sizeof(char) * c_buff_len);

    if (c_buff == NULL) {
        print_str("ERROR WITH MALLOC");
        new_line();
    }
    else {
        print_str("malloc gave an address");
        new_line();
    }

    clear_buff();
}