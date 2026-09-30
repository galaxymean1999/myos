#ifndef SCREEN_H
#define SCREEN_H

#include <stdint.h>

#define TEXT_WIDTH 80
#define TEXT_HEIGHT 25

#define VGA_INDEX_PORT 0x3d4
#define VGA_DATA_PORT 0x3d5

#define u8  uint8_t
#define u16 uint16_t

static volatile unsigned short* video_memory = (volatile unsigned short*)0xb8000;

static inline void out(u16 port, u8 value);

void set_cursor_position(u8 x, u8 y);

void update_cursor_position();

void put_char(u8 x, u8 y, char c, u8 color);

void print_str(char *str);

void new_line();

void clear_screen();

int get_cursor_x();
int get_cursor_y();

#endif