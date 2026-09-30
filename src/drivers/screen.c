#include "screen.h"

uint8_t cursor_x = 0;
uint8_t cursor_y = 0;

void print_str(char *str) {
    int i = 0;
    while (str[i] != 0) {
        put_char(cursor_x, cursor_y, str[i], (unsigned char)0x0f);
        i++;
    }
}

void put_char(u8 x, u8 y, char c, u8 color) {
    unsigned short character = color << 8 | c;
    video_memory[y * TEXT_WIDTH + x] = character;

    cursor_x++;

    if (cursor_x >= 80) {
        new_line();
    }
    else {
        update_cursor_position();
    }
}

void clear_screen() {
    for (int i = 0; i < TEXT_WIDTH * TEXT_HEIGHT * 2; i++) {
        video_memory[i] = 0x0f << 8 | ' ';
    }

    cursor_x = 0;
    cursor_y = 0;

    update_cursor_position();
}

void set_cursor_position(u8 x, u8 y) {
    u16 offset = y * TEXT_WIDTH + x;

    out(VGA_INDEX_PORT, 0x0f);

    out(VGA_DATA_PORT, (u8)(offset & 0xff));

    out(VGA_INDEX_PORT, 0x0e);

    out(VGA_DATA_PORT, (u8)((offset >> 8) & 0xff));

    cursor_x = x;
    cursor_y = y;
}

void new_line() {
    cursor_x = 0;
    cursor_y++;

    update_cursor_position();
}

void update_cursor_position() {
    set_cursor_position(cursor_x, cursor_y);
}

static inline void out(u16 port, u8 value) {
    __asm__ volatile ("out %0, %1" : : "a"(value), "Nd"(port));
}

int get_cursor_x() {
    return cursor_x;
}

int get_cursor_y() {
    return cursor_y;
}