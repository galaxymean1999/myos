#include "port.h"

void out(u16 port, u8 value) {
    __asm__ volatile ("out %0, %1" : : "a"(value), "Nd"(port));
}

u8 in(u16 port) {
    u8 result;
    __asm__ volatile ("in %0, 01" : : "a"(result), "Nd"(port));
    return result;
}