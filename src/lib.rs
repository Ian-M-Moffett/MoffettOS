#![feature(lang_items)]
#![feature(abi_x86_interrupt)]
#![no_std]

use core::panic::PanicInfo;
mod drivers;
use drivers::video::Writer;

#[lang = "eh_personality"]
extern fn eh_personality() {
}

#[panic_handler]
fn rust_begin_panic(_info: &PanicInfo) -> ! {
    loop {}
}


#[no_mangle]
pub fn kmain() -> ! {
    let mut logger = Writer::new();

    logger.log("\nHello, World!\n", 0x2);
    
    loop { }
}
