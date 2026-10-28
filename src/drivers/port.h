#ifndef PORTS_H
#define PORTS_H

#include "typedefs.h"

#define out(port, value) \
    __asm__ volatile ("out %0, %1" : : "a"((u8)value), "Nd"((u16)port))

//void out(u16 port, u8 value);

u8 in(u16 port);

#endif
