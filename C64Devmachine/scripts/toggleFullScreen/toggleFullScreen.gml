function toggleFullScreen() {
    if (global.fullScreen) {
        window_set_fullscreen(true);
    }
    
    if (!global.fullScreen) {
        window_set_fullscreen(false);
        window_set_size(global.win_w, global.win_h);
        window_set_position(global.win_x, global.win_y);
    }
    // Persist fullscreen state
    ini_open("c64devmachine.ini");
    ini_write_real("window", "fullscreen", global.fullScreen);
    ini_close();
}