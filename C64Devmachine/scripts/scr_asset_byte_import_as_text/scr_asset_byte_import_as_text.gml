/// @desc Import a .txt file into a BYTE_DATA asset (treated as raw text until compile)
function scr_asset_byte_import_as_text(_asset) {
    var _path = get_open_filename("Text File|*.txt;*.text|All Files|*.*", "");
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
        scr_show_message("BYTE IMPORT: Could not open file.");
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
    // Strip RTF wrapper if TextEdit saved as RTF — extract content after \cf0
    if (string_pos("\\rtf1", _str) > 0) {
        var _search  = "\\cf0 ";
        var _found   = string_pos(_search, _str);
        var _cf0_pos = (_found > 0) ? (_found + string_length(_search)) : 0;
        if (_cf0_pos > 0) {
            _str = string_copy(_str, _cf0_pos, string_length(_str) - _cf0_pos + 1);
            _str = string_replace_all(_str, "}", "");
            _str = string_replace_all(_str, "\r", "");
            _str = string_replace_all(_str, "\n", "");
        } else {
            scr_show_message("BYTE IMPORT: Could not parse RTF content.\nPlease save as plain text (.txt) first.");
            exit;
        }
    }
    _asset.file                  = _path;
    _asset.meta.byte_string      = _str;
    _asset.meta.inline_edit_text = _str;
    scr_asset_byte_data_save(_asset);
    show_debug_message("BYTE IMPORT: OK — " + filename_name(_path)
        + "  chars=" + string(string_length(_str))
        + "  bytes=" + string(buffer_get_size(_asset.buffer)));
    global.undo_dirty = true;
    if (variable_struct_exists(_asset, "meta")) {
        _asset.meta._mtime = md5_file(_asset.file);
    }
}