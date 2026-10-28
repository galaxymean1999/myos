#include "malloc.h"

void heap_init(void *raw_memory_start, size_t total_heap_size) {
    heap_start = (BlockHeader*)raw_memory_start;
    heap_start->size = total_heap_size - HEADER_SIZE;
    heap_start->is_free = 1;
    heap_start->next = NULL;
}

void *mem_alloc(u8 requested_size) {
    if (requested_size == 0) {
        return NULL;
    }

    size_t size = ALIGN(requested_size);
    BlockHeader *current = heap_start;

    // check if the block is free
    while (current != NULL) {
        if (current->is_free && current->size >= size) {
            if (current->size >= (size + HEADER_SIZE + ALIGNMENT)) {
                BlockHeader *new_block = (BlockHeader*)(current + HEADER_SIZE + size);
                new_block->size = current->size - size - HEADER_SIZE;
                new_block->is_free = 1;
                new_block->next = current->next;
                current->next = new_block;
                current->size = size;
            }
            current->is_free = 0;
            return (void*)(current + HEADER_SIZE);
        }
        current = current->next;
    }

    // out of memory
    return NULL;
}

void free(void *ptr) {
    if (ptr == NULL) {
        return;
    }

    BlockHeader *block = (BlockHeader*)(ptr - HEADER_SIZE);
    block->is_free = 1;

    BlockHeader *current = heap_start;
    while (current != NULL) {
        // if the next block is free
        if (current->is_free && current->next && current->next->is_free) {
            current->size += HEADER_SIZE + current->next->size;

            current->next = current->next->next;
        }
        else {
            current = current->next;
        }
    }
}