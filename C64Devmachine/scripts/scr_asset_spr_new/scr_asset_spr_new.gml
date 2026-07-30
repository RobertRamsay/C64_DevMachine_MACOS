/// @function scr_asset_spr_new(_asset)
/// @desc Initialise a freshly-created sprite asset to a single blank sprite.
///       Allocates only what is needed (1 slot), with the + button in the
///       picker handling growth up to a max of 64.
function scr_asset_spr_new(_asset) {
    // Single 64-byte sprite block, zeroed (one blank sprite).
    if (buffer_exists(_asset.buffer)) buffer_delete(_asset.buffer);
    _asset.buffer = buffer_create(64, buffer_fixed, 1);
    buffer_fill(_asset.buffer, 0, buffer_u8, 0, 64);

    // Meta sized to exactly 1 slot.
    _asset.meta.used_count  = 1;
    _asset.meta.spr_sprites = array_create(1, -1);
    _asset.meta.sprite_mcs  = array_create(1, 0);
    _asset.meta.sprite_ucs  = array_create(1, 1);
    _asset.meta.bg_col      = 0;
    _asset.meta.mc1_col     = 1;
    _asset.meta.mc2_col     = 2;

    scr_asset_spr_cache_sprites(_asset, true);
}