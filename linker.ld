ENTRY(_start)

/* Note: BLOCK(4K) ensures the section takes up space at multiples of 4KB
My guess is that this is to support paging
*/
SECTIONS
{
    . = 2M;
    .text BLOCK(4K) : ALIGN(4K)
    {
        *(.multiboot)
        *(.text)
    }

    .rodata BLOCK(4K) : ALIGN(4K) 
    {
        *(.rodata)
    }

    .data BLOCK(4K) : ALIGN(4K) 
    {
        *(.data)
    }
    .bss BLOCK(4K) : ALIGN(4K)
    {
        *(COMMON)
        *(.bss)
    }
}