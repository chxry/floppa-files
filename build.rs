use std::fs;
use std::process::Command;

fn main() {
  Command::new(if cfg!(windows) { "cmd" } else { "sh" })
    .args([
      if cfg!(windows) { "/C" } else { "-c" },
      "tailwindcss -i templates/main.css -o static/main.css --minify",
    ])
    .output()
    .expect("failed to run tailwind");
}
