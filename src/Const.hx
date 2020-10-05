class Const {
	public static var FPS = 60;
	public static var FIXED_FPS = 30;
	public static var AUTO_SCALE_TARGET_WID = 640; // -1 to disable auto-scaling on width
	public static var AUTO_SCALE_TARGET_HEI = 400; // -1 to disable auto-scaling on height
	public static var SCALE = 1.0; // ignored if auto-scaling
	// public static var SCALE = 2.0; // ignored if auto-scaling
	public static var GRID = 24;

	static var _uniq = 0;
	public static var NEXT_UNIQ(get,never) : Int; static inline function get_NEXT_UNIQ() return _uniq++;
	public static var INFINITE = 999999;

	static var _inc = 0;
	public static var DP_BG = _inc++;
	public static var DP_FX_BG = _inc++;
	public static var DP_MAIN = _inc++;
	public static var DP_FRONT = _inc++;
	public static var DP_FX_FRONT = _inc++;
	public static var DP_TOP = _inc++;
	public static var DP_UI = _inc++;
	public static var DP_HUD = _inc++;
	public static var DP_NOTEPAD = _inc++;
	public static var DP_UPGRADE = _inc++;

	public static inline var BUTTON_WIDTH = 100;
	public static inline var BUTTON_HEIGHT = 50;
	
	public static var LED_DATA : LedData;

	public static var PLAYER_DATA : PlayerData;

	public static function INIT() {
		LED_DATA = new LedData();

		PLAYER_DATA = dn.LocalStorage.readObject("playerData", {maximumNotepadEntry:3, maximumInventoryStorage:2, planningDatas:new Map()});
	}

	public static function SAVE_PROGRESS() {
		dn.LocalStorage.writeObject("playerData", PLAYER_DATA);
	}

	public static var NOTEPAD_SPACING = 50;
	public static var NB_LIGN_PER_PAGE = 5;
}
