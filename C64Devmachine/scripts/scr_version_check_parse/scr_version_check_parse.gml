/// @function scr_version_check_parse(body_text)
/// @description Parses the version file body and sets workspace manager flags.
/// @param {string} body_text  Raw text from the remote version file.
function scr_version_check_parse(_body)
{
    with (obj_workspace_manager)
    {
        version_check_request = -1;
        version_check_done    = true;
        version_check_failed  = false;
        
        // Normalise line endings, split into lines.
        var _norm   = string_replace_all(_body, "\r\n", "\n");
        _norm       = string_replace_all(_norm, "\r", "\n");
        var _lines  = string_split(_norm, "\n");
        var _count  = array_length(_lines);
        
        if (_count < 1)
        {
            version_check_failed = true;
            return;
        }
        
        // Trim each line. Line 1 is required.
        version_remote_string = string_trim(_lines[0]);
        
        if (_count >= 2)
        {
            version_remote_date = string_trim(_lines[1]);
        }
        else
        {
            version_remote_date = "";
        }
        
        if (_count >= 3)
        {
            version_remote_url = string_trim(_lines[2]);
        }
        else
        {
            version_remote_url = "https://polytricity.itch.io/the-c64-dev-machine";
        }
        
        if (_count >= 4)
        {
            // Join remaining lines as notes.
            var _notes = "";
            var _i = 3;
            repeat (_count - 3)
            {
                if (_notes != "")
                {
                    _notes += "\n";
                }
                _notes += _lines[_i];
                _i += 1;
            }
            version_remote_notes = _notes;
        }
        else
        {
            version_remote_notes = "";
        }
        
        // Sanity check: line 1 must look like a version.
        if (string_length(version_remote_string) <= 0 || string_length(version_remote_string) > 32)
        {
            version_check_failed = true;
            return;
        }
        
        // If the remote version string has changed since the user last
        // dismissed a banner, reset the dismiss flag so the new version
        // can show its banner.
        if (version_remote_string != version_last_seen_remote)
        {
            version_banner_dismissed = false;
            version_last_seen_remote = version_remote_string;
        }
        
        // Compare against GM_version. Different = update available.
        // =============================================================
        // Compare remote version against GM_version, segment by segment.
        // Only flag an update if remote is STRICTLY NEWER than local.
        // Handles "0.9.9.72" vs "0.9.9.71" correctly (numeric per segment).
        // =============================================================
        var _local_str  = string(GM_version);
        var _remote_str = version_remote_string;
        
        // Strip an optional leading "v" / "V" on either side.
        if (string_char_at(_local_str, 1) == "v" || string_char_at(_local_str, 1) == "V")
        {
            _local_str = string_delete(_local_str, 1, 1);
        }
        if (string_char_at(_remote_str, 1) == "v" || string_char_at(_remote_str, 1) == "V")
        {
            _remote_str = string_delete(_remote_str, 1, 1);
        }
        
        var _local_parts  = string_split(_local_str,  ".");
        var _remote_parts = string_split(_remote_str, ".");
        
        // ---------------------------------------------------------
        // Both platforms now publish a clean 3-segment version
        // (e.g. "1.0.1" = major.minor.patch), so we just compare
        // those three segments directly - no more trying to split
        // Mac's collapsed "0.99.72" style back into 4 parts.
        // Anything past the 3rd segment is ignored; anything
        // missing counts as 0.
        // ---------------------------------------------------------
        var _local_count  = array_length(_local_parts);
        var _remote_count = array_length(_remote_parts);
        var _max_count    = 3;

        
        var _remote_is_newer = false;
        var _decided         = false;
        
        var _i = 0;
        repeat (_max_count)
        {
            var _l_seg = 0;
            var _r_seg = 0;
            
            if (_i < _local_count)
            {
                _l_seg = real(string_digits(_local_parts[_i]));
            }
            if (_i < _remote_count)
            {
                _r_seg = real(string_digits(_remote_parts[_i]));
            }
            
            if (!_decided)
            {
                if (_r_seg > _l_seg)
                {
                    _remote_is_newer = true;
                    _decided = true;
                }
                else if (_r_seg < _l_seg)
                {
                    _remote_is_newer = false;
                    _decided = true;
                }
                // equal -> continue to next segment
            }
            
            _i += 1;
        }
        
        // Debug — remove once confirmed working
        var _dbg_local  = "";
        var _dbg_remote = "";
        var _di = 0;
        repeat (array_length(_local_parts))
        {
            if (_dbg_local != "") { _dbg_local += "."; }
            _dbg_local += string(_local_parts[_di]);
            _di += 1;
        }
        _di = 0;
        repeat (array_length(_remote_parts))
        {
            if (_dbg_remote != "") { _dbg_remote += "."; }
            _dbg_remote += string(_remote_parts[_di]);
            _di += 1;
        }
        show_debug_message("VERSION CHECK: local=" + _local_str + " (norm " + _dbg_local + ") remote=" + _remote_str + " (norm " + _dbg_remote + ") remote_is_newer=" + string(_remote_is_newer));
        show_debug_message("VERSION CHECK pre-flags: update_available=" + string(version_update_available) + " banner_dismissed=" + string(version_banner_dismissed) + " banner_visible=" + string(version_banner_visible));
        
        if (_remote_is_newer)
        {
            version_update_available = true;
            
            if (!version_banner_dismissed)
            {
                version_banner_visible = true;
            }
            else
            {
                version_banner_visible = false;
            }
        }
        else
        {
            version_update_available = false;
            version_banner_visible   = false;
        }
        
        show_debug_message("VERSION CHECK post-flags: update_available=" + string(version_update_available) + " banner_dismissed=" + string(version_banner_dismissed) + " banner_visible=" + string(version_banner_visible) + " id=" + string(id));
    }
}