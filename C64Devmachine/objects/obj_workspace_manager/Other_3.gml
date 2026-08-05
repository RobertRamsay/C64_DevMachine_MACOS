// ---------------------------------------------------------------
// Game End: SILENT persistence only.
// NEVER call show_question / show_message / file dialogs here.
// On macOS this runs inside [NSApplication terminate:]; a native
// dialog spins up a nested run loop, re-enters exit(), and crashes
// the runtime (RParticleSystemManager / CLayerManager, EXC_BAD_ACCESS).
// The interactive "save before closing?" prompt lives on the in-app
// X icon (Draw GUI -> "exit_confirm"). The real macOS red X cannot
// be safely intercepted, so here we just save silently if we can.
// ---------------------------------------------------------------
ini_open("c64devmachine.ini");
ini_write_real("window", "x", global.win_x);
ini_write_real("window", "y", global.win_y);
ini_write_real("window", "w", global.win_w);
ini_write_real("window", "h", global.win_h);
ini_write_real("editor", "font_index", code_editor_font_index);
ini_write_real("Settings", "bkgImg", bkgImg);
ini_write_real("Settings", "showGrid", showGrid);
ini_write_real("Settings", "paletteStyle", paletteStyle);
ini_write_real("Settings", "niceSliceFrm", niceSliceFrm);
ini_write_real("Settings", "expert_mode", expert_mode ? 1 : 0);
ini_write_real("Settings", "opcode_helper", opcode_helper_on ? 1 : 0);
ini_write_real("Settings", "palette_helper", showPaletteHelper ? 1 : 0);
ini_write_real("Settings", "visual_fx", global.visual_fx ? 1 : 0);
ini_write_real("Settings", "comments_visible", global.comments_visible ? 1 : 0);
ini_write_real("Settings", "opcode_headers", opcode_headers_on ? 1 : 0);
ini_write_real("Settings", "opcode_extra_height", opcode_extra_height ? 1 : 0);
ini_close();

// Silent save on quit ONLY if we have an existing path.
// No dialog, no Save As (file picker would re-enter the run loop).
if (!global.manual_saved) {
    if (global.workspace_path != "") {
        scr_save_workspace_as_path(global.workspace_path);
		alarm[9]=100;
    }
}
