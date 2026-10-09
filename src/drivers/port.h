#ifndef PORTS_H
#define PORTS_H

typedef unsigned char	uint8_t;
typedef unsigned short	uint16_t;
typedef unsigned int	uint32_t;

typedef uint8_t		u8;
typedef uint16_t	u16;
typedef uint32_t	u32;

#define out(port, value) \
    __asm__ volatile ("out %0, %1" : : "a"((u8)value), "Nd"((u16)port))

//void out(u16 port, u8 value);

u8 in(u16 port);

#endif
