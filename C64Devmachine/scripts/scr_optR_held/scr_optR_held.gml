/// @function scr_cmd_held()
/// @description Returns true if either left opt key is held on Mac. Maps to raw keycodes 91 (left) and 92 (right).
function scr_optR_held()
{
    if (keyboard_check(165))
    {
        return true;
    }

    return false;
}