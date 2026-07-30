/// @desc Deferred Autosave Check (Safe for Mac)
ini_open("c64devmachine.ini");
var _last_autosave = ini_read_string("autosave", "last_path", "");
ini_close();
if (global.autosave_mode != 3) {
    if (_last_autosave != "" && file_exists(_last_autosave)) {
        
        var _answer = show_question("Autosave detected:\n" + filename_name(_last_autosave) + "\n\nLoad it?");
        
        // Armor against Mac's "Yes" vs Windows' boolean return values
        if (string(_answer) == "Yes" || string(_answer) == "1" || string(_answer) == "true") {
            scr_load_workspace_from_path(_last_autosave);
        }
    }
}