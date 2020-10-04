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

		createRootInLayers(game.root, Const.DP_HUD);
		root.filter = new h2d.filter.ColorMatrix(); // force pixel perfect rendering

		mainFlow = new h2d.Flow(root);
		mainFlow.horizontalAlign = Middle;
		mainFlow.layout = Vertical;
		mainFlow.verticalSpacing = 5;
		
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
		mainFlow.y = Std.int((game.scroller.y / Const.UI_SCALE) + game.level.lvlData.pxHei + 10);
	}

	public inline function invalidate() invalidated = true;

	function render() {
		textTU.text = "Current Time Unit : " + level.currentTU;

		inventoryFlow.removeChildren();
		for (object in level.player.inventory) {
			switch (object.type) {
				case Coffee : Assets.tiles.h_get("iconCoffee", inventoryFlow);
				case Files : Assets.tiles.h_get("iconFile", inventoryFlow);
				case Photocopy : Assets.tiles.h_get("iconPhotocopy", inventoryFlow);
			}
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
