pub const PINS = enum(u5) {
    PA0 = 0x00,
    PA1,
    PA2,
    PA3,
    PA4,
    PA5,
    PA6,
    PA7,
    PA8,
    PA9,
    PA10,
    PA11,
    PA12,
    PA13,
    PA14,
    PA15, // 15
    PB0, // 16
    PB1,
    PB2,
    PB3,
    PB4,
    PB5,
    PB6,
    PB7,
    PB8,
    PB9,
    PB10,
    PB11,
    PB12,
    PB13,
    PB14,
    PB15,
};

pub const PIN_MODE = enum(u2) {
    INPUT = 0b00,
    OUTPUT = 0b01,
    ALTERNATE = 0b10,
    ANALOG = 0b11,
};

pub const PUPDR_MODE = enum(u2) {
    NORMAL = 0b00,
    PULL_UP = 0b01,
    PULL_DOWN = 0b10,
};
