#include  "stdio.h"

size_t length_of(char *buff) {
    size_t length = 0;
    while (buff[length] != 0) {
        length++;
    }

    return length;
}

u8 str_cmp(char *str1, char *str2) {
    int i = 0;

    while (str1[i] == str2[i]) {
        if (str1[i] == 0) {
            return 1;
        }
        i++;
    }

    return 0;
}

void reboot() {
    unsigned long volatile idt_ptr[2] = {0, 0};
    asm volatile ("lidt (%0)" : : "r"(idt_ptr));

    asm volatile ("int $3");
}