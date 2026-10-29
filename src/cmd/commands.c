#include "commands.h"
#include "../universal/stdio.h"

void fetch_command(char *buff) {
    if (length_of(buff) == 0) {
        return;
    }

    if (str_cmp(buff, "BOBIK")) {
        new_line();
        print_str("LOVE YOUUUU!");
    }
    else if (str_cmp(buff, "REBOOT")) {
        new_line();
        print_str("REBOOTING NOW...");

        reboot();
    }
    else if (str_cmp(buff, "CLEAR")) {
        clear_screen();
    }
    else if (str_cmp(buff, "HELP")) {
        new_line();
        print_str("REBOOT - reboots the computer");
        new_line();
        print_str("CLEAR - clears the screen");
    }

    else {
        new_line();
        print_str("INVALID COMMAND!!!");
    }
}