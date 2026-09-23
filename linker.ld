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
    .kernel :
    {
        kernel.o(.text)
        kernel.o(.data)
        kernel.o(.rodata)
        kernel.o(.bss)
    }
}