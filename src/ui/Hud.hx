package ui;

class Hud extends dn.Process {
	public var game(get,never) : Game; inline function get_game() return Game.ME;
	public var fx(get,never) : Fx; inline function get_fx() return Game.ME.fx;
	public var level(get,never) : Level; inline function get_level() return Game.ME.level;

	var mainFlow : h2d.Flow;
	var inventoryFlow : h2d.Flow;
	var invalidated = true;

	var textTU : h2d.Text;

	public function new() {
		super(Game.ME);

		createRootInLayers(game.root, Const.DP_UI);
		root.filter = new h2d.filter.ColorMatrix(); // force pixel perfect rendering

		mainFlow = new h2d.Flow(root);
		mainFlow.horizontalAlign = Middle;
		mainFlow.layout = Vertical;
		mainFlow.verticalSpacing = 5;
		mainFlow.debug = true;
		
		textTU = new h2d.Text(Assets.fontPixel, mainFlow);

		inventoryFlow = new h2d.Flow(mainFlow);
		inventoryFlow.horizontalSpacing = 10;
	}

	override function onResize() {
		super.onResize();
		root.setScale(Const.UI_SCALE);

		inventoryFlow.reflow();

		mainFlow.minWidth = Std.int(w() / Const.SCALE);
		mainFlow.reflow();
		mainFlow.y = Std.int((h() / Const.SCALE) * 0.8);
	}

	public inline function invalidate() invalidated = true;

	function render() {
		textTU.text = "Current Time Unit : " + level.currentTU;

		inventoryFlow.removeChildren();
		for (type in level.player.inventory) {
			var color = switch type {
				case Coffee: 0x865528;
				case Files: 0xeedc8c;
			}
			new h2d.Bitmap(h2d.Tile.fromColor(color, 20, 20), inventoryFlow);
		}

		onResize();
	}

	override function postUpdate() {
		super.postUpdate();

		if( invalidated ) {
			invalidated = false;
			render();
		}
	}
}
