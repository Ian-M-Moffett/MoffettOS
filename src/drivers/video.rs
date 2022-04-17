pub struct Writer {
    posx: u64,
    posy: u64,
    buffer: *mut u8
}

// const BUFFER_HEIGHT: u64 = 25;
const BUFFER_WIDTH: u64 = 80;

impl Writer { 
    pub fn new() -> Self {
        Self { posx: 0, posy: 0, buffer: unsafe {&mut *(0xB8000 as *mut u8)} }
    }

    pub fn logb(&mut self, byte: u8, color: u8) {
        let loc: *mut u8 = (self.buffer as u64 + 320 * self.posy + self.posx) as *mut u8;
        let colorloc: *mut u8 = (self.buffer as u64 + 320 * self.posy + self.posx + 1) as *mut u8;

        unsafe {
            *loc = byte;
            self.posx += 2;

            if self.posx >= BUFFER_WIDTH {
                self.posx = 0;
                self.posy += 1;
            }

            *colorloc = color;
        }
    }

    fn posreturn(&mut self) {
        self.posx = 0;
    }

    fn posnewline(&mut self) {
        self.posx = 0;
        self.posy += 1;
    }

    pub fn log(&mut self, s: &str, color: u8) {
        for byte in s.bytes() {
            match byte {
                0xA => {
                    self.posnewline();
                    continue;
                },

                0xD => {
                    self.posreturn();
                    continue;
                },

                _ => {}
            }

            self.logb(byte, color);
        }
    }
}
