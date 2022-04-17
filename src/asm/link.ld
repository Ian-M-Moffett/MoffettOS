ENTRY(start)

SECTIONS {
    . = 1M;        /* Sections start at 1MB */
    
    boot :      /*  Create a section named boot. */
    {
        /* Every section named multiboot_header goes into boot section. */
        *(.multiboot_header)
    }
    
    text :          /* Create a section named text */
    {
        *(.text)    /* Put every section label named text here. */
    }

    rodata :
    {
        *(.rodata)
    }
}
