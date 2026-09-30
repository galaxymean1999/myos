#ifndef SCREEN_H
#define SCREEN_H

#define TEXT_WIDTH 80
#define TEXT_HEIGHT 25

static volatile unsigned short* video_memory = (volatile unsigned short*)0xb8000;

void put_char(int x, int y, char c, unsigned char color);

void print_str(char *str);

void clear_screen();

int get_cursor_x();
int get_cursor_y();

#endif