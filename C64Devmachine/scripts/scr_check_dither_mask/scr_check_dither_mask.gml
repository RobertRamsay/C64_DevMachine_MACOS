function scr_check_dither_mask(_mode, _x, _y) {
    if (_mode == "NONE") return true;
    
    // MC column (0-3), raw row (0-7)
  // var _mc_x = (_x div 2) mod 4;
  // var _mc_y = _y mod 8;
	
// MC column (0-3), raw row (0-7), double-wrapped for negative coordinate safety
var _mc_x = (((_x div 2) mod 4) + 4) mod 4;
var _mc_y = ((_y mod 8) + 8) mod 8;
    
    if (_mode == "CHECKER")   return ((_mc_x + _mc_y) mod 2 == 0);
    if (_mode == "INTERLACE") return (_mc_y mod 2 == 0);
    
    // True MC-aware Bayer: 4 columns x 8 rows = 32 threshold levels
    // Derived from standard Bayer8 by sampling even columns only
    static _bayer_mc = [
         0, 8, 2,10,
        24,16,26,18,
        12, 4,14, 6,
        28,20,30,22,
         3,11, 1, 9,
        27,19,25,17,
        15, 7,13, 5,
        31,23,29,21
    ];
    
    var _threshold = -1;
    switch (_mode) {
        case "BAYER_4":  _threshold =  1; break;  // ~6%
        case "BAYER_8":  _threshold =  3; break;  // ~12%
        case "BAYER_12": _threshold =  5; break;  // ~18%
        case "BAYER_16": _threshold =  7; break;  // ~25%
        case "BAYER_20": _threshold =  9; break;  // ~31%
        case "BAYER_24": _threshold = 11; break;  // ~37%
        case "BAYER_28": _threshold = 15; break;  // ~43%
        case "BAYER_32": _threshold = 17; break;  // ~50%
        case "BAYER_36": _threshold = 19; break;  // ~56%
        case "BAYER_40": _threshold = 21; break;  // ~62%
        case "BAYER_44": _threshold = 23; break;  // ~68%
        case "BAYER_48": _threshold = 25; break;  // ~75%
        case "BAYER_52": _threshold = 27; break;  // ~81%
        case "BAYER_56": _threshold = 29; break;  // ~87%
        case "BAYER_60": _threshold = 31; break;  // ~93%
    }
    
    if (_threshold >= 0) {
        return (_bayer_mc[_mc_y * 4 + _mc_x] <= _threshold);
    }
    
    return true;
}