ENTRY(Reset_Handler)

 /* Initial stack pointer (0x20018000) */
_Min_Heap_Size = 0x200;
_Min_Stack_Size = 0x400;

MEMORY
{
  FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 512K
  RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 96K
}
_estack = ORIGIN(RAM) + LENGTH(RAM);
SECTIONS
{
  /* Vector table */
  .isr_vector :
    {
        KEEP(*(.isr_vector))
    } > FLASH

  /* Code + read-only data */
  .text :
  {
    . = ALIGN(4);
    *(.text*)
    *(.rodata*)
    *(.glue_7) *(.glue_7t)
    KEEP(*(.init)) KEEP(*(.fini))
    . = ALIGN(4);
    _etext = .;
  } > FLASH

  /* ARM unwind info */
  .ARM.extab :
  {
    . = ALIGN(4);
    *(.ARM.extab*)
    . = ALIGN(4);
  } > FLASH

  .ARM.exidx :
  {
    . = ALIGN(4);
    __exidx_start = .;
    *(.ARM.exidx*)
    __exidx_end = .;
    . = ALIGN(4);
  } > FLASH

  /* Init data copied from FLASH to RAM */
  _sidata = LOADADDR(.data);
  .data : AT(_etext + SIZEOF(.ARM.extab) + SIZEOF(.ARM.exidx))
  {
    . = ALIGN(4);
    _sdata = .;
    *(.data*) *(.RamFunc*)
    . = ALIGN(4);
    _edata = .;
  } > RAM

  /* Uninitialized data (zeroed) */
  .bss :
  {
    . = ALIGN(4);
    _sbss = .; __bss_start__ = _sbss;
    *(.bss*) *(COMMON)
    . = ALIGN(4);
    _ebss = .; __bss_end__ = _ebss;
  } > RAM

  /* Heap and stack (top-down) */
  ._user_heap_stack (NOLOAD):
  {
    . = ALIGN(8);
    PROVIDE(_end = .);
    . = . + _Min_Heap_Size;
    . = . + _Min_Stack_Size;
    . = ALIGN(8);
  } > RAM
}
