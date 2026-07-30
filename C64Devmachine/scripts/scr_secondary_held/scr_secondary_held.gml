/// @function scr_primary_held()
/// @description Returns true if left mouse is held OR the OPT key is held.
function scr_secondary_held() {
    return mouse_check_button(mb_right || scr_optR_held());
}

