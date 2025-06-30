.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

.global  g_pfnVectors
.global  Reset_Handler
.global  Default_Handler

/* Linker script symbols */
.extern _estack
.extern _sidata
.extern _sdata
.extern _edata
.extern _sbss
.extern _ebss

/* Vector Table */
.section .isr_vector, "a", %progbits
.type g_pfnVectors, %object
g_pfnVectors:
    .word _estack               /* Initial Stack Pointer */
    .word Reset_Handler         /* Reset Handler */
    .word Default_Handler       /* NMI Handler */
    .word Default_Handler       /* HardFault Handler */
    .word Default_Handler       /* MemManage Handler */
    .word Default_Handler       /* BusFault Handler */
    .word Default_Handler       /* UsageFault Handler */
    .word 0                     /* Reserved */
    .word 0                     /* Reserved */
    .word 0                     /* Reserved */
    .word 0                     /* Reserved */
    .word Default_Handler       /* SVCall Handler */
    .word Default_Handler       /* Debug Monitor Handler */
    .word 0                     /* Reserved */
    .word Default_Handler       /* PendSV Handler */
    .word Default_Handler       /* SysTick Handler */

/* Reset Handler */
.section .text.Reset_Handler
.type Reset_Handler, %function
Reset_Handler:
    ldr   sp, =_estack

    ldr   r0, =_sdata
    ldr   r1, =_edata
    ldr   r2, =_sidata

CopyDataLoop:
    cmp   r0, r1
    bge   CopyDataDone
    ldr   r3, [r2], #4
    str   r3, [r0], #4
    b     CopyDataLoop

CopyDataDone:
    ldr   r0, =_sbss
    ldr   r1, =_ebss
    movs  r2, #0

ZeroBssLoop:
    cmp   r0, r1
    bge   ZeroBssDone
    str   r2, [r0], #4
    b     ZeroBssLoop

ZeroBssDone:
    bl    _start

LoopForever:
    b LoopForever


.size Reset_Handler, .-Reset_Handler

/* Default Handler */
.section .text.Default_Handler, "ax", %progbits
.type Default_Handler, %function
Default_Handler:
Infinite_Loop:
    b Infinite_Loop
.size Default_Handler, .-Default_Handler
