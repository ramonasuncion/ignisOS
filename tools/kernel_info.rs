#!/usr/bin/env cargo

//! ```cargo
//! [dependencies]
//! num-traits = {version = "0.2" }
//! ```

use std::process::Command;
// use std::io::{self, Write};
// use num_traits::Float;


// ls -l build/kernel.bin # ceil(size / 512)
// x86_64-elf-readelf -h build/kernel.elf | grep "Entry point"
// x86_64-elf-nm build/kernel.elf | grep kmain
// ls -l build/*.bin | awk '{sum += $5} END {print sum, "bytes used"}
// x86_64-elf-nm build/kernel.elf

fn main() {
    println!("Hello, World!");
    //match run_command("ls", &["-l"]) {
    //    _ => todo!(),
    //    //Ok(file) => file,
    //    //Err(error) => panic!("Problem opening the file: {error:?}"),
    //}
}

fn run_command(command: &str, args: &[&str]) { // -> Result<String, io::Error> {
    let output = Command::new(command)
        .args(args)
        .output();// ?;

    //if !out.status.success() {
    //    // String::from_utf8_lossy(&out.stderr);
    //}

    // todo: be able to get output and stringify it b/c doc says to stdout

    // Ok(String::from_utf8_lossy(&out.stdout));
}
