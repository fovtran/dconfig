use std::process::Command;

fn main()
{
//let mut options = std::run::ProcessOptions::new();
//let process = std::run::Process::new("ls", &[your, arguments], options);

let output = Command::new("/usr/bin/ffmpeg")
                     .arg("-h")
                     .output()
                     .expect("failed to execute process");

println!("status: {}", output.status);
println!("stdout: {}", String::from_utf8_lossy(&output.stdout));
println!("stderr: {}", String::from_utf8_lossy(&output.stderr));

assert!(output.status.success());
}