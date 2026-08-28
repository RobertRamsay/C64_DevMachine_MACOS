/// @desc Import a .txt file into a TEXT_DATA asset
function scr_asset_txt_import(_asset) {
    var _path = (argument_count > 1 && argument[1] != "") ? argument[1] : get_open_filename("Text File|*.txt;*.text|All Files|*.*", "");
    // A native file dialog takes focus, so the key-up that ends the keypress is
    // delivered to the dialog and not to the game. GameMaker is left thinking the
    // key is still held, and keyboard_check_pressed() needs an up->down edge — so
    // ESC silently stops working until the input state is reset. This is why ESC
    // only failed after SOME asset operations: scr_asset_sid_import already did
    // this, every other importer did not.
    io_clear();
    if (_path == "") {
        exit;
    }
    var _buf = buffer_load(_path);
    if (_buf < 0) {
        show_message("TEXT IMPORT: Could not open file.");
        exit;
    }
    var _str = "";
    var _bsz = buffer_get_size(_buf);
    for (var _bi = 0; _bi < _bsz; _bi++) {
        var _ch = buffer_peek(_buf, _bi, buffer_u8);
        if (_ch != 0) {
            _str += chr(_ch);
        }
    }
    buffer_delete(_buf);
    // Strip CR/LF — single line for scroller
    _str = string_replace_all(_str, "\r", "");
    _str = string_replace_all(_str, "\n", "");
    while (string_length(_str) > 0 && string_char_at(_str, string_length(_str)) == " ") {
        _str = string_delete(_str, string_length(_str), 2);
    }
    _asset.file          = _path;
    _asset.meta.text     = _str;
    scr_asset_text_flush(_asset);
    show_debug_message("TEXT IMPORT: OK — " + filename_name(_path)
        + "  chars=" + string(string_length(_str))
        + "  bytes=" + string(buffer_get_size(_asset.buffer)));
    global.undo_dirty = true;
    if (variable_struct_exists(_asset, "meta")) {
        _asset.meta._mtime = md5_file(_asset.file);
    }
}