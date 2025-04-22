use std::process::Command;
use std::io;

fn main() {
    // Run `ls -l build/kernel.bin`
    match run_command("ls", &["-l", "build/kernel.bin"]) {
        Ok(out) => {
            let size = out.split_whitespace().nth(4).unwrap_or("0");
            let size: u64 = size.parse().unwrap();
            println!("Size of kernel.bin: {} bytes", size)
        }
        Err(e) => eprintln!("Error running 'ls': {}", e),
    }

    // Run `x86_64-elf-readelf -h build/kernel.elf | grep "Entry point"`
    match run_command("x86_64-elf-readelf", &["-h", "build/kernel.elf"]) {
        Ok(out) => {
            out.lines();
            // break into multiple lines
            // find the line that has entry point
            // extract line
            // extract the entry point
            println!("{}", out);
        }
        Err(e) => eprintln!("Error running 'x86_64-elf-readelf': {}", e),
    }

    // Run `x86_64-elf-nm build/kernel.elf | grep kmain`
    match run_command("x86_64-elf-nm", &["build/kernel.elf"]) {
        Ok(_out) => {
        },
        Err(e) => eprintln!("Error running 'x86_64-elf-nm': {}", e),
    }

    // Run `ls -l build/*.bin | awk '{sum += $5} END {print sum, "bytes used"}`
    //match run_command("ls", &["-l", "build/*.bin"]) {
    //    Ok(out) => {
    //    },
    //    Err(e) => eprintln!(""),
    //}

    // Run `x86_64-elf-nm build/kernel.elf`
    //match run_command("x86_64-elf-nm", &["build/kernel.elf"]) {
    //    Ok(out) => {
    //        println!("Symbols in kernel.elf:\n{}", out);
    //    }
    //    Err(e) => eprintln!("Error running 'x86_64-elf-nm': {}", e),
    //}
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

