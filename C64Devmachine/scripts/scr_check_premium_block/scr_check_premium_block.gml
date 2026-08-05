/// @function scr_check_premium_block(_action_verb)
/// @description  Checks whether the current spine contains any PRO-only nodes
///               and, if so, shows a native blocking yes/no dialog offering to
///               open the store page. Returns true if the caller should ABORT
///               its operation (i.e. PRO content was found in LITE mode).
/// @param {string} _action_verb  E.g. "BUILDING" or "EXPORTING" — used in the prompt.
/// @returns {bool}  true = abort, false = continue
function scr_check_premium_block(_action_verb) {
    if (global.lite != 1) return false; // Full version — never blocks

    var _premium_found = false;
    with (obj_c64_node) {
        if (variable_instance_exists(id, "egg_temp") && egg_temp) continue;
        if (is_connected && (node_type == "MACRO_CODE" || node_type == "MACRO_IRQ" || node_type == "MACRO_MOVE_MEM" )) {
            _premium_found = true;
            break;
        }
    }
    if (!_premium_found) return false;

    var _msg = _action_verb + " NON-DEMO FEATURES\n\n"
             + "Your spine contains premium nodes (Code or IRQ) which cannot be "
             + string_lower(_action_verb) + " in the Demo version.\n\n"
             + "PLEASE CONSIDER PURCHASING.\nWould you like to open the store page now?";

    var _r = show_question(_msg);
    var _yes = is_string(_r) ? (string_lower(_r) == "yes") : bool(_r);
    if (_yes) {
        url_open("https://polytricity.itch.io/the-c64-dev-machine");
    }
    return true; // Caller must abort regardless of yes/no
}
