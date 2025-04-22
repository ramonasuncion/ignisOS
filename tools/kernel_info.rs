use std::process::Command;
use std::io;

fn main() {
    // Run ls -l build/kernel.bin
    match run_command("ls", &["-l", "build/kernel.bin"]) {
        Ok(out) => {

        }
        Err(e) => eprintln!("Error runing 'ls': {}", e),
    }

    // Run x86_64-elf-readelf -h build/kernel.elf | grep "Entry point"
    match run_command("x86_64-elf-readelf", &["-h", "build/kernel.elf"]) {
        Ok(out) => {
        }
        Err(e) => eprintln!("Error runing 'x86_64-elf-readelf': {}", e),
    }

    // Run x86_64-elf-nm build/kernel.elf | grep kmain

    // Run ls -l build/*.bin | awk '{sum += $5} END {print sum, "bytes used"}

    // Run x86_64-elf-nm build/kernel.elf
}

fn run_command(command: &str, args: &[&str]) -> Result<String, io::Error> {
    let out = Command::new(command)
        .args(args)
        .output()?;

    if !out.status.success() {
        return Err(io::Error::new(io::ErrorKind::Other, format!("Command failed: {:?}", out)));
    }

    Ok(String::from_utf8_lossy(&out.stdout).to_string())
}

