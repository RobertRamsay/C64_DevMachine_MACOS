/// @function scr_cmd_held()
/// @description Returns true if either left opt key is held on Mac. Maps to raw keycodes 91 (left) and 92 (right).
function scr_opt_released()
{
    if (keyboard_check_released(164))
    {
        return true;
    }

    return false;
}