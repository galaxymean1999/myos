#include "keyboard.h"

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
