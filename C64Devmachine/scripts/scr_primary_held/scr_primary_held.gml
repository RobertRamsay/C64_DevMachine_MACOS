/// @function scr_primary_held()
/// @description Returns true if left mouse is held OR the OPT key is held.
function scr_primary_held() {
    return mouse_check_button(mb_left) || scr_opt_held();
}

