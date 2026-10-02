#ifndef SCREEN_H
#define SCREEN_H

#include "port.h"

#define TEXT_WIDTH 80
#define TEXT_HEIGHT 25

#define VGA_INDEX_PORT 0x3d4
#define VGA_DATA_PORT 0x3d5

static volatile unsigned short* video_memory = (volatile unsigned short*)0xb8000;

void set_cursor_position(u8 x, u8 y);

void update_cursor_position();

void put_char(u8 x, u8 y, char c, u8 color);

void print_str(char *str);

void new_line();

void clear_screen();

int get_cursor_x();
int get_cursor_y();

#endif