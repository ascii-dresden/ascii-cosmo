use embedded_svc::wifi::{ClientConfiguration, Configuration as WifiConfiguration};
use embedded_svc::{http::Method, io::Write};
use esp_idf_hal::{
    delay::FreeRtos,
    gpio::{PinDriver, Pull},
    ledc::{config::TimerConfig, LedcDriver, LedcTimerDriver},
    peripherals::Peripherals,
    units::*,
};

use esp_idf_svc::{
    eventloop::EspSystemEventLoop,
    http::server::{Configuration, EspHttpServer},
    nvs::EspDefaultNvsPartition,
    sys::EspError,
    wifi::EspWifi,
};
use heapless::String;
use std::sync::atomic::{AtomicBool, Ordering};

static SENSOR_STATE: AtomicBool = AtomicBool::new(false);

fn main() {
    // It is necessary to call this function once. Otherwise some patches to the runtime
    // implemented by esp-idf-sys might not link properly. See https://github.com/esp-rs/esp-idf-template/issues/71
    esp_idf_svc::sys::link_patches();

    // Bind the log crate to the ESP Logging facilities
    esp_idf_svc::log::EspLogger::initialize_default();

    log::info!("Hello, world!");

    let peripherals = Peripherals::take().expect("Failed to take peripherals");
    let mut led = PinDriver::output(peripherals.pins.gpio7).expect("Failed to create led driver");
    let mut motor_sleep =
        PinDriver::output(peripherals.pins.gpio5).expect("Failed to create motor sleep driver");
    motor_sleep.set_low().unwrap();
    led.set_high().expect("Failed to set led high");
    let mut sensor =
        PinDriver::input(peripherals.pins.gpio4).expect("Failed to create sensor driver");
    sensor.set_pull(Pull::Down).unwrap();

    let timer_driver = LedcTimerDriver::new(
        peripherals.ledc.timer0,
        &TimerConfig::default().frequency(5.kHz().into()),
    )
    .expect("Failed to create LED timer driver");
    let mut motor = LedcDriver::new(
        peripherals.ledc.channel0,
        timer_driver,
        peripherals.pins.gpio6,
    )
    .expect("Failed to create LED driver");

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

    while !wifi_driver.is_connected().unwrap() {
        FreeRtos::delay_ms(1000);
        log::info!("Waiting for connection...");
    }

    let mut server =
        EspHttpServer::new(&Configuration::default()).expect("Failed to create webserver");
    server
        .fn_handler("/", Method::Get, move |request| {
            let state = SENSOR_STATE.load(Ordering::Relaxed);
            let mut response = request
                .into_ok_response()
                .expect("Failed to create response");
            response
                .write_all(format!("State: {state}").as_bytes())
                .expect("Failed to send response");
            Ok::<(), EspError>(())
        })
        .expect("Failed to handle request");

    let max_duty = motor.get_max_duty();
    motor.set_duty(max_duty / 2).unwrap();
    led.set_low().expect("Failed to set led low");
    loop {
        let level = sensor.get_level();
        SENSOR_STATE.store(bool::from(level), Ordering::Relaxed);
        led.set_level(level).unwrap();
        motor_sleep.set_level(level).unwrap();
        FreeRtos::delay_ms(50);
    }
}
