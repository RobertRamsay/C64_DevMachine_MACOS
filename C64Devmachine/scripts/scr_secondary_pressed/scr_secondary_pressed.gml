/// @function scr_primary_pressed()
/// @description Returns true if left mouse is pressed OR the OPT key is pressed.
function scr_secondary_pressed() {
    return mouse_check_button_pressed(mb_right) || scr_optR_pressed();
}

