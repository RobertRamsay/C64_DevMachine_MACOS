/// @desc Deferred Folder Prompt (Safe for Mac)

var _dir_valid = (global.project_dir != "" && directory_exists(global.project_dir));

if (!_dir_valid) {
    show_message("Welcome! Please select or create a dedicated working folder where your project files and .prg builds will live.");
    
    var _setup_path = get_save_filename("Project Folder|*.txt", "SELECT_THIS_FOLDER.txt");
    
    if (_setup_path != "") {
        global.project_dir = filename_dir(_setup_path) + "/";
        
        ini_open("c64devmachine.ini");
        ini_write_string("Settings", "project_dir", global.project_dir);
        ini_close();
    } else {
        show_debug_message("WARNING: Defaulting to scratchpad folder.");
        global.project_dir = export_dir; 
    }
    
    // Recalculate full path strings now that we have the directory
    if (global.project_name != "") {
        file_name = global.project_name + ".prg";
        full_save_path = global.project_dir + file_name;
    }
}

// Cascade to Alarm 6 with a tiny delay so the Mac doesn't lock up from double dialogs!
alarm[6] = 5;