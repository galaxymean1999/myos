#ifndef PORT_H
#define PORT_H

#include <stdint.h>

#define u8  uint8_t
#define u16 uint16_t

#define bool u8
#define true 1
#define false 0

void out(u16 port, u8 value);

u8 in(u16 port);

#endif