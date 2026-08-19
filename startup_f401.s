.section .isr_vector, "a", %progbits
.align 2

.global vector_table

    .word 0x20018000          /* Initial stack pointer */
    .word Reset_Handler
    .word NMI_Handler
    .word HardFault_Handler

    .word 0                    /* MemManage */
    .word 0                    /* BusFault */
    .word 0                    /* UsageFault */
    .word 0
    .word 0
    .word 0
    .word 0

    .word SVC_Handler
    .word 0                    /* DebugMonitor */
    .word 0
    .word PendSV_Handler
    .word SysTick_Handler

.section .bss
.align 2

milliseconds:
    .space 4                   /* uint32_t */

.section .text
.align 2
.global Reset_Handler

.thumb_func
Reset_Handler:
    bl _start;

.thumb_func
NMI_Handler:
    b NMI_Handler

.thumb_func
HardFault_Handler:
    b HardFault_Handler

.thumb_func
SVC_Handler:
    b SVC_Handler


.thumb_func
PendSV_Handler:
    b PendSV_Handler

.thumb_func
SysTick_Handler:
    ldr r0, =milliseconds
    ldr r1, [r0]

    add r1, r1, #1

    str r1, [r0]

    bx lr
