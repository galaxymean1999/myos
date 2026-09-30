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
        load_pm.o(.rodata)
        load_pm.o(.bss)
    }

    .kernel :
    {
        kernel.o(.text)
        kernel.o(.data)
    }

    .screen :
    {
        screen.o(.text)
        screen.o(.data)
    }
}