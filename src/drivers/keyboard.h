#ifndef KEYBOARD_H
#define KEYBOARD_H

#include "port.h"

#define KEYBOARD_DATA_PORT 0x60
#define KEYBOARD_STATUS_PORT 0x64

static const char scan_code_table[] = {
    0,  27, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', '\b',
    '\t', 'Q', 'W', 'E', 'R', 'T', 'Z', 'U', 'I', 'O', 'P', '[', ']', '\n',
    0,  'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ';', '\'', '`',   0,
    '\\', 'Y', 'X', 'C', 'V', 'B', 'N', 'M', ',', '.', '/',   0,   '*',   0, ' '
};

unsigned char key_available();

char get_key_ascii();

#endif
