const pins = @import("pins.zig");

const RCC_BASE: usize = 0x40023800;
const RCC_AHB1ENR: *volatile u32 = @ptrFromInt(RCC_BASE + 0x30);

const GPIO = struct {
    base: usize,
    moder: *volatile u32,
    odr: *volatile u32,
    idr: *volatile u32,
    pupdr: *volatile u32,
    clock_offset: u5,

    fn init(base: usize, clock_offset: u5) GPIO {
        return GPIO{
            .base = base,
            .moder = @ptrFromInt(base + 0x00),
            .pupdr = @ptrFromInt(base + 0x0C),
            .idr = @ptrFromInt(base + 0x10),
            .odr = @ptrFromInt(base + 0x14),
            .clock_offset = clock_offset,
        };
    }

    pub fn initClock(self: GPIO) void {
        RCC_AHB1ENR.* |= @as(u32, 1) << self.clock_offset;
    }

    pub fn toggle(self: GPIO, pin: pins.PINS) void {
        const mask = @as(u32, 1) << getShift(pin);
        self.odr.* ^= mask;
    }
    pub fn digitalRead(self: GPIO, pin: pins.PINS) bool {
        const shift: u5 = getShift(pin);
        var value = false;

        //debaounce digital reading
        for (1..100) |_| {
            value = ((self.idr.* >> shift) & 1) != 0;
        }
        return value;
    }
    pub fn setPupdr(
        self: GPIO,
        pin: pins.PINS,
        mode: pins.PUPDR_MODE,
    ) void {
        const shift: u5 = getShift(pin) * 2;
        const mode_value: u32 = @intFromEnum(mode);
        self.pupdr.* =
            (self.pupdr.* & ~(@as(u32, 0b11) << shift)) |
            (mode_value << shift);
    }

    pub fn setMode(
        self: GPIO,
        pin: pins.PINS,
        mode: pins.PIN_MODE,
    ) void {
        const shift: u5 = getShift(pin) * 2;
        const mode_value: u32 = @intFromEnum(mode);

        self.moder.* =
            (self.moder.* & ~(@as(u32, 0b11) << shift)) |
            (mode_value << shift);
    }
};

fn getShift(pin: pins.PINS) u5 {
    const value = @intFromEnum(pin);
    const upper_limit = @intFromEnum(pins.PINS.PA15);
    if (value > upper_limit)
        return value - 16;
    return value;
}

pub const GPIOA: GPIO = GPIO.init(
    0x40020000,
    0,
);

pub const GPIOB: GPIO = GPIO.init(
    0x40020400,
    1,
);
