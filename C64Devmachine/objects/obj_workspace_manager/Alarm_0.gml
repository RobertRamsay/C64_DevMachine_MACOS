/// @desc Alarm 0: Relaunch VICE (Wait for file)

// 1. Check if the compiler has finished creating the file
if (!file_exists(full_save_path))
{
    // File isn't ready yet. Check again in 15 frames.
    show_debug_message("Waiting for build to finish...");
    alarm[0] = 15;
    exit; // Stop running the rest of this code for now
}

// 2. The file exists! Proceed with the launch.
show_debug_message("FILE EXISTS: 1 - Launching VICE!");

var _vice_app_path = global.vice_path_cache;

// Build ONE shell command that does everything in sequence:
//   1) kill any running VICE (pkill non-zero if no match is fine)
//   2) strip quarantine (idempotent)
//   3) launch VICE with the PRG
// Running these as a single spawn (instead of three rapid ProcessExecuteAsync
// calls) avoids overrunning the process extension's result buffer, which
// crashes (SIGABRT / stack buffer overflow in libxprocess) when the killed
// VICE from a previous build is reaped at the same time as new spawns.
var _inner = "";
_inner += "pkill -x x64sc; pkill -x x64; ";
_inner += "xattr -dr com.apple.quarantine \\\"" + _vice_app_path + "\\\"; ";
_inner += "/usr/bin/open -n -a \\\"" + _vice_app_path + "\\\" --args -autostart \\\"" + full_save_path + "\\\"";

var _launch_command = "/bin/sh -c \"" + _inner + "\"";

show_debug_message("LAUNCH COMMAND: " + _launch_command);
var temp = ProcessExecuteAsync(_launch_command);
show_debug_message("LAUNCH RESULT: " + string(temp));
show_debug_message("VICE PATH: " + _vice_app_path);
show_debug_message("PRG PATH: " + full_save_path);