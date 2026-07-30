/// @function scr_strip_key_ghosts(_str)
/// @description Removes non-printable control chars and macOS arrow/function
///              key private-use chars (0xF700+) from a keyboard_string value.
function scr_strip_key_ghosts(_str) {
    var _clean = "";
    var _len = string_length(_str);
    for (var _i = 1; _i <= _len; _i++) {
        var _ch = string_char_at(_str, _i);
        var _ord = ord(_ch);
        if (_ord >= 32 && _ord != 127 && _ord < 0xF700) {
            _clean += _ch;
        }
    }
    return _clean;
}