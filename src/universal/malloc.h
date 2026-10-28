#ifndef MALLOC_H
#define MALLOC_H

#define ALIGNMENT 16
#define ALIGN(size) (((size) + (ALIGNMENT - 1)) & ~(ALIGNMENT - 1))

#include "typedefs.h"

typedef struct BlockHeader {
    u8 is_free;
    size_t size;
    struct BlockHeader *next;
} BlockHeader;

#define HEADER_SIZE ALIGN(sizeof(BlockHeader))

static BlockHeader *heap_start = NULL;

void heap_init(void *raw_memory_start, size_t total_heap_size);

void *mem_alloc(u8 requested_size);

void free(void *ptr);

#endif