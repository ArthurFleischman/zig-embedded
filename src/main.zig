const timer = @import("timer/timer.zig");
const PIN_MODE = @import("gpio/pins.zig").PIN_MODE;
const PUPDR_MODE = @import("gpio/pins.zig").PUPDR_MODE;
const GPIOA = @import("gpio/gpio.zig").GPIOA;
const GPIOB = @import("gpio/gpio.zig").GPIOB;
const PB4 = @import("gpio/pins.zig").PINS.PB4;
const PA5 = @import("gpio/pins.zig").PINS.PA5;
export fn _start() noreturn {
    timer.systick_init();
    timer.setupTimer2();
    GPIOA.initClock();
    GPIOB.initClock();
    GPIOA.setMode(PA5, PIN_MODE.OUTPUT);
    GPIOB.setMode(PB4, PIN_MODE.INPUT);

    // Blink loop
    var x = true;

    while (true) {
        for (1..100) |_| {
            x = GPIOB.digitalRead(PB4);
        }
        if (x) {
            GPIOA.toggle(PA5);
            timer.delayMicros(1_000_000);
        }
    }
}
