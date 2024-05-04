use esp_idf_hal::{delay::FreeRtos, gpio::PinDriver, peripherals::Peripherals};

fn main() {
    // It is necessary to call this function once. Otherwise some patches to the runtime
    // implemented by esp-idf-sys might not link properly. See https://github.com/esp-rs/esp-idf-template/issues/71
    esp_idf_svc::sys::link_patches();

    // Bind the log crate to the ESP Logging facilities
    esp_idf_svc::log::EspLogger::initialize_default();

    log::info!("Hello, world!");

    let peripherals = Peripherals::take().expect("Failed to take peripherals");
    let mut led = PinDriver::output(peripherals.pins.gpio9).expect("Failed to create led driver");
    loop {
        led.toggle().expect("Failed to toggle led");
        FreeRtos::delay_ms(500);
    }
}
