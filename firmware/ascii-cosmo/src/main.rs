use embedded_svc::wifi::{ClientConfiguration, Configuration as WifiConfiguration};
use esp_idf_hal::{
    delay::FreeRtos,
    gpio::{PinDriver, Pull},
    peripherals::Peripherals,
};
use esp_idf_svc::{eventloop::EspSystemEventLoop, nvs::EspDefaultNvsPartition, wifi::EspWifi};
use heapless::String;

fn main() {
    // It is necessary to call this function once. Otherwise some patches to the runtime
    // implemented by esp-idf-sys might not link properly. See https://github.com/esp-rs/esp-idf-template/issues/71
    esp_idf_svc::sys::link_patches();

    // Bind the log crate to the ESP Logging facilities
    esp_idf_svc::log::EspLogger::initialize_default();

    log::info!("Hello, world!");

    let peripherals = Peripherals::take().expect("Failed to take peripherals");
    let mut led = PinDriver::output(peripherals.pins.gpio9).expect("Failed to create led driver");
    let mut button =
        PinDriver::input(peripherals.pins.gpio4).expect("Failed to create button driver");
    button.set_pull(Pull::Down).unwrap();

    let sysloop = EspSystemEventLoop::take().expect("Failed to take sysloop");
    let nvs = EspDefaultNvsPartition::take().expect("Failed to take nvs");
    let mut wifi_driver = EspWifi::new(peripherals.modem, sysloop, Some(nvs))
        .expect("Failed to initialize wifi driver");
    let mut ssid: String<32> = String::new();
    let mut password: String<64> = String::new();
    ssid.push_str(env!("COSMO_WIFI_SSID"))
        .expect("Failed to handle SSID");
    password
        .push_str(env!("COSMO_WIFI_PASSWORD"))
        .expect("Failed to handle password");

    wifi_driver
        .set_configuration(&WifiConfiguration::Client(ClientConfiguration {
            ssid,
            password,
            ..Default::default()
        }))
        .expect("Failed to configure wifi");

    wifi_driver.start().expect("Failed to start wifi");
    wifi_driver.connect().expect("Failed to connect to wifi");

    loop {
        led.set_level(button.get_level()).unwrap();
        FreeRtos::delay_ms(50);
    }
}
