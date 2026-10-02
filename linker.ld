OUTPUT_FORMAT("binary")
ENTRY(start)

SECTIONS
{
    /DISCARD/ :
    {
        *(.note*)
        *(.comment)
        *(.eh_frame)
    }

    . = 0x7c00;
    .bootloader : SUBALIGN(1)
    {
        boot.o(.text*)
        boot.o(.data*)
        boot.o(.rodata*)

        . = 510;
        SHORT(0xaa55);
    }

    . = 0x7e00;
    .load_pm : SUBALIGN(1)
    {
        load_pm.o(.text)
        load_pm.o(.data)
    }

    .kernel : SUBALIGN(1)
    {
        kernel.o(.text)
        kernel.o(.data)
    }

    .c_main : SUBALIGN(1)
    {
        main.o(.text)
        main.o(.rodata*)
        main.o(.data)
        main.o(.bss)
        *(.text)
        *(.rodata*)
        *(.data)
        *(.bss*)
    }
}