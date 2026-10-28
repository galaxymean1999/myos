#ifndef STDIO_H
#define STDIO_H

#include "../drivers/keyboard.h"
#include "../drivers/screen.h"
#include "malloc.h"
#include "typedefs.h"

size_t length_of(char *buff);

u8 str_cmp(char *str1, char *str2);

void reboot();

#endif