/* Declare constants for the multiboot header. */
.set ALIGN,   1<<0               /* align loaded modules on page boundaries */
.set MEMINFO, 1<<1               /* provide memory map */
.set FLAGS,   ALIGN | MEMINFO    /* Mutiboot 'flag' field */
.set MAGIC,   0xBADB002          /* Bootloader finds header via magic number */
.set CHECKSUM, -(MAGIC + FLAGS)  /* Sum of checksum, magic, flags = 0 */ 
                                 /* For error detection */

/* 
Declare a multiboot header that marks the program as a kernel.
Look for more documentation in the multiboot standard.
Bootloader searches for this "signature" in the first KiB of kernel file, 
aligned at 32-bit boundary. Signature is in its own section, so the header can
be forced to be within the first 8 KiB of the kernel file.
We place this section seperately to allow it to be in the first 8KiB of the file
*/
.section .multiboot              /* Start a new section named multiboot */
.align 4                         /* Align to a 4 byte boundary */
.long MAGIC                      /* Store 32 bit integer in multiboot section */
.long FLAGS
.long CHECKSUM

/*
Kernel must provide stack -> multiboot standard does not define value of the 
stack pointer register.
Stack on x86 grows downward
Stack register on x86 is named "ESP" (Extended stack pointer)
Stack on x86 must be 16-byte aligned according to System V ABI standard and 
de-facto extensions. 
*/
.section .bss
.align 16
stack_bottom:        /* label that marks the beginning of the stack */
.skip 16384 # 16KiB  /* skip reserves a block of memory in this bss section */
stack_top:           /* label that marks the end of the stack */

.section .text
.global _start
.type _start, @function
_start:
    mov $stack_top, %esp

    call kernel_main

    cli
1:  hlt
    jmp 1b

.size _start, . - _start