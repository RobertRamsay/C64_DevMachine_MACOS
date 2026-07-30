/// @function scr_primary_released()
/// @description Returns true if left mouse is released OR the OPT key is released.
function scr_secondary_released() {
    return mouse_check_button_released(mb_right) || scr_optR_released();
}