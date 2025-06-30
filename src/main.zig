const GPIOA_BASE: u32 = 0x40020000;
const RCC_BASE: u32 = 0x40023800;

const std = @import("std");

const GPIOA_MODER: *volatile u32 = @ptrFromInt(GPIOA_BASE + 0x00);
const GPIOA_ODR: *volatile u32 = @ptrFromInt(GPIOA_BASE + 0x14);
const RCC_AHB1ENR: *volatile u32 = @ptrFromInt(RCC_BASE + 0x30);

const SYST_CSR: *volatile u32 = @ptrFromInt(0xE000E010); // Control and Status
// const SYST_RVR: *volatile u32 = @ptrFromInt(0xE000E014); // Reload Value
// const SYST_CVR: *volatile u32 = @ptrFromInt(0xE000E018); // Current Value
// const SYST_CALIB: *volatile u32 = @ptrFromInt(0xE000E01C); // Calibration (optional)

const CPU_FREQ_HZ = 84_000_000;

export fn _start() noreturn {
    //systick_init();
    // Enable GPIOA clock
    RCC_AHB1ENR.* |= 1 << 0;

    // Configure PA5 as output
    GPIOA_MODER.* &= ~(@as(u32, 0b11) << (5 * 2)); // clear bits
    GPIOA_MODER.* |= (@as(u32, 0b01) << (5 * 2)); // set to output

    // Blink loop
    while (true) {
        GPIOA_ODR.* ^= 1 << 5;
        delayMs(10);
    }
}

pub fn delayMs(ms: u32) void {
    var i: u32 = 0;
    while (i < ms) : (i += 1) {
        while (((SYST_CSR.* >> 16) & 1) == 0) {
            // wait for COUNTFLAG
        }
    }
}
// pub fn systick_init() void {
//     const ticks_per_ms: u32 = (CPU_FREQ_HZ / 8) / 1000;

//     SYST_CSR.* =
//         (0 << 2) | // CLKSOURCE = AHB / 8
//         (1 << 1) | // TICKINT: Enable interrupt
//         (1 << 0); // ENABLE: Start counter

//     SYST_RVR.* = ticks_per_ms - 1;
// }
