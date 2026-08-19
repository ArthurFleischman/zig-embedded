const build_options = @import("config");
const RCC_BASE = 0x4002_3800;
const TIM2_BASE = 0x4000_0000;
const SYST_CSR: *volatile u32 = @ptrFromInt(0xE000E010); // Control and Status
const SYST_RVR: *volatile u32 = @ptrFromInt(0xE000E014); // Reload Value
const CPU_FREQ_HZ = build_options.cpu_freq;

const RCC = struct {
    CR: u32,
    PLLCFGR: u32,
    CFGR: u32,
    CIR: u32,
    AHB1RSTR: u32,
    AHB2RSTR: u32,
    _pad0: [2]u32,
    APB1RSTR: u32,
    APB2RSTR: u32,
    _pad1: [2]u32,
    AHB1ENR: u32,
    AHB2ENR: u32,
    _pad2: [2]u32,
    APB1ENR: u32,
    APB2ENR: u32,
};

const TIM = struct {
    CR1: u32,
    CR2: u32,
    SMCR: u32,
    DIER: u32,
    SR: u32,
    EGR: u32,
    CCMR1: u32,
    CCMR2: u32,
    CCER: u32,
    CNT: u32,
    PSC: u32,
    ARR: u32,
};

fn rcc() *volatile RCC {
    return @ptrFromInt(RCC_BASE);
}

pub fn tim2() *volatile TIM {
    return @ptrFromInt(TIM2_BASE);
}

pub fn setupTimer2() void {
    // Enable TIM2 clock
    rcc().APB1ENR |= 1 << 0;

    // Stop timer
    tim2().CR1 = 0;

    // Reset counter
    tim2().CNT = 0;

    // 16 MHz / 16 = 1 MHz
    // Therefore 1 tick = 1 us
    tim2().PSC = 15;

    // Free-running 32-bit counter
    tim2().ARR = 0xFFFF_FFFF;

    // Generate an update event so PSC takes effect
    tim2().EGR = 1;

    // Start timer
    tim2().CR1 = 1;
}

fn micros() u32 {
    return tim2().CNT;
}

pub fn delayMicros(us: u32) void {
    const start = micros();

    while (micros() -% start < us) {}
}

pub fn systick_init() void {
    const ticks_per_ms: u32 = (CPU_FREQ_HZ / 1000);
    SYST_CSR.* =
        (0 << 2) | // CLKSOURCE = AHB / 8
        (1 << 1) | // TICKINT: Enable interrupt
        (1 << 0); // ENABLE: Start counter

    SYST_RVR.* = ticks_per_ms - 1;
}
