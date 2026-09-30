OUTPUT_FORMAT("binary")
ENTRY(start)

SECTIONS
{
    . = 0x7c00;
    .bootloader :
    {
        boot.o(.text)
        boot.o(.data)
        boot.o(.rodata)

        . = 510;
        SHORT(0xaa55);
    }

    . = 0x7e00;
    .load_pm :
    {
        load_pm.o(.text)
        load_pm.o(.data)
    }

    .kernel :
    {
        kernel.o(.text)
        kernel.o(.data)
    }

    /*.screen :
    {
        screen.o(.text)
        screen.o(.data)
    }*/

    .c_main :
    {
        mainc.o(.text)
        mainc.o(.rodata*)
        mainc.o(.data)
        mainc.o(.bss)
        *(.text)
        *(.rodata*)
        *(.data)
        *(.bss*)
    }
}