/// @function scr_primary_released()
/// @description Returns true if left mouse is released OR the OPT key is released.
function scr_primary_released() {
    return mouse_check_button_released(mb_left) || scr_opt_released();
}