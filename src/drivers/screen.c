#include "screen.h"

int cursor_x = 0;
int cursor_y = 0;

void print_str(char *str) {
    int i = 0;
    while (str[i] != 0) {
        put_char(cursor_x, cursor_y, str[i], (unsigned char)0x0f);
        i++;
        cursor_x++;
        if (cursor_x == 80) {
            cursor_y++;
            cursor_x = 0;
        }
    }
}

void put_char(int x, int y, char c, unsigned char color) {
    unsigned short character = color << 8 | c;
    video_memory[y * TEXT_WIDTH + x] = character;
}

void clear_screen() {
    for (int i = 0; i < TEXT_WIDTH * TEXT_HEIGHT * 2; i++) {
        video_memory[i] = 0x0f << 8 | ' ';
    }
}

int get_cursor_x() {
    return cursor_x;
}

int get_cursor_y() {
    return cursor_y;
}