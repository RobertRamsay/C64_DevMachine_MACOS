/// @function scr_asset_spr_add_blank_slot(_asset)
/// @desc Appends one blank sprite slot to a SPRITE_SET asset without
///       opening the V2 editor. Grows the packed buffer by 64 bytes,
///       extends the meta mode/uc arrays, bumps used_count (cap 64), and
///       rebuilds the thumbnail cache. No-op at the 64-slot bank cap.
function scr_asset_spr_add_blank_slot(_asset) {

    if (!variable_struct_exists(_asset, "meta")) exit;

    var _used = 1;
    if (variable_struct_exists(_asset.meta, "used_count")) {
        _used = _asset.meta.used_count;
    }
    if (_used >= 64) {
        show_debug_message("ADD_BLANK_SLOT: already at 64-slot cap");
        exit;
    }

    var _new_slot   = _used;
    var _new_count  = _used + 1;
    var _new_size   = _new_count * 64;

    if (!buffer_exists(_asset.buffer)) {
        _asset.buffer = buffer_create(_new_size, buffer_fixed, 1);
        buffer_fill(_asset.buffer, 0, buffer_u8, 0, _new_size);
    } else {
        buffer_resize(_asset.buffer, _new_size);
        for (var _b = 0; _b < 64; _b++) {
            buffer_poke(_asset.buffer, _new_slot * 64 + _b, buffer_u8, 0);
        }
    }

    if (!variable_struct_exists(_asset.meta, "sprite_mcs")) {
        _asset.meta.sprite_mcs = array_create(_new_count, 0);
    } else {
        array_resize(_asset.meta.sprite_mcs, _new_count);
        _asset.meta.sprite_mcs[_new_slot] = 0;
    }
    if (!variable_struct_exists(_asset.meta, "sprite_ucs")) {
        _asset.meta.sprite_ucs = array_create(_new_count, 1);
    } else {
        array_resize(_asset.meta.sprite_ucs, _new_count);
        _asset.meta.sprite_ucs[_new_slot] = 1;
    }

    _asset.meta.used_count = _new_count;
    if (variable_struct_exists(_asset.meta, "total_size")) {
        _asset.meta.total_size = _new_size;
    }

    if (variable_struct_exists(_asset.meta, "hex_blob")) {
        var _hex = "";
        buffer_seek(_asset.buffer, buffer_seek_start, 0);
        repeat(_new_size) {
            _hex += decimal_to_hex(buffer_read(_asset.buffer, buffer_u8));
        }
        _asset.meta.hex_blob = _hex;
    }

    scr_asset_spr_cache_sprites(_asset, true);

    global.undo_dirty = true;
    global.memory_bar_dirty = true;
    show_debug_message("ADD_BLANK_SLOT: added slot " + string(_new_slot)
        + " (used_count now " + string(_new_count) + ")");
}