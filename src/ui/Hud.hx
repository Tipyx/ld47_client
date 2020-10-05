package ui;

import dn.heaps.HParticle;

class Hud extends dn.Process {
	public var game(get,never) : Game; inline function get_game() return Game.ME;
	public var fx(get,never) : Fx; inline function get_fx() return Game.ME.fx;
	public var level(get,never) : Level; inline function get_level() return Game.ME.level;

	var mainFlow : h2d.Flow;
	var inventoryFlow : h2d.Flow;
	var invalidated = true;

	var textRemainingTU : h2d.Text;
	var textcurrentTU : h2d.Text;
	var inventoryRemaining : h2d.Text;

	var sprItems : Array<HSprite>;

	var pool : ParticlePool;

	var fxSb : h2d.SpriteBatch;

	public function new() {
		super(Game.ME);

		createRootInLayers(game.root, Const.DP_HUD);
		root.filter = new h2d.filter.ColorMatrix(); // force pixel perfect rendering

		var bg = Assets.tiles.h_get("bgHUD", 0, 0, 0, root);

		mainFlow = new h2d.Flow(root);
		mainFlow.horizontalAlign = Middle;
		mainFlow.layout = Vertical;
		mainFlow.verticalSpacing = 15;
		mainFlow.minWidth = Std.int(bg.tile.width);
		mainFlow.paddingTop = 20;
		
		textRemainingTU = new h2d.Text(Assets.fontExpress9 /* , mainFlow */);
		textcurrentTU = new h2d.Text(Assets.fontExpress9, mainFlow);
		inventoryRemaining = new h2d.Text(Assets.fontExpress9, mainFlow);
		textRemainingTU.textColor = textcurrentTU.textColor = inventoryRemaining.textColor = 0x292524;
		textRemainingTU.dropShadow = textcurrentTU.dropShadow = inventoryRemaining.dropShadow = {dx: 0, dy:1, alpha: 1, color:0x8e8052};

		mainFlow.addSpacing(-10);

		inventoryFlow = new h2d.Flow(mainFlow);
		inventoryFlow.multiline = true;
		// inventoryFlow.debug = true;
		inventoryFlow.horizontalSpacing = inventoryFlow.verticalSpacing = 8;
		inventoryFlow.paddingTop = 4;
		inventoryFlow.paddingLeft = 4;
		inventoryFlow.maxWidth = inventoryFlow.minWidth = 24 * hxd.Math.imin(Const.PLAYER_DATA.maximumInventoryStorage, 3);
		inventoryFlow.minHeight = 24 * (Std.int(Const.PLAYER_DATA.maximumInventoryStorage / 3) + 1);

		for (i in 0...Const.PLAYER_DATA.maximumInventoryStorage) {
			var spr = Assets.tiles.h_get("bgInventory", inventoryFlow);
			inventoryFlow.getProperties(spr).isAbsolute = true;
			spr.setPosition(i % 3 * 24, Std.int(i / 3) * 24);
		}

		sprItems = [];

		pool = new ParticlePool(Assets.tiles.tile, 2048, Const.FPS);

		fxSb = new h2d.SpriteBatch(Assets.tiles.tile);
		root.add(fxSb, Const.DP_FX_FRONT);
		// fxSb.blendMode = Add;
		fxSb.hasRotationScale = true;
	}
	
	inline function allocTopAdd(t:h2d.Tile, x:Float, y:Float) : HParticle {
		return pool.alloc(fxSb, t, x, y);
	}

	inline function getTile(id:String) : h2d.Tile {
		return Assets.tiles.getTileRandom(id);
	}

	public function fxInventoryFull() {
		for (i in 0...10) {
			var p = allocTopAdd(getTile("fxSquare"), inventoryFlow.x + (inventoryFlow.outerWidth >> 1), inventoryFlow.y + (inventoryFlow.outerHeight >> 1));
			p.scaleX = hxd.Math.imin(Const.PLAYER_DATA.maximumInventoryStorage, 3);
			p.scaleY = Std.int(Const.PLAYER_DATA.maximumInventoryStorage / 3) + 1;
			p.ds = 0.1;
			p.colorize(0xFF0000);
			p.alpha = 0.5;
			p.delayS = 0.1 * i;
			p.lifeS = 0.25;
		}
	}

	override function onResize() {
		super.onResize();
		root.setScale(Const.SCALE);

		inventoryFlow.reflow();

		mainFlow.reflow();

		root.x = Std.int((game.scroller.x) + game.level.lvlData.pxWid * Const.SCALE + 10);
		root.y = Std.int(game.scroller.y);

		// root.x = game.scroller.x;
		// root.y = game.scroller.y;
	}

	public inline function invalidate() invalidated = true;

	function render() {
		// textRemainingTU.text = 'Remaining TU : ${level.lvlInfo.maximumScore - level.currentTU}';
		// textcurrentTU.text = 'TU : ${level.currentTU}';
		textcurrentTU.text = "TU : " + level.currentTU + " / " + level.lvlInfo.maximumScore;
		inventoryRemaining.text = "Inventory";

		for (spr in sprItems) spr.remove();
		sprItems = [];
		for (object in level.player.inventory) {
			var spr = switch (object.type) {
				case Coffee : Assets.tiles.h_get("iconCoffee", inventoryFlow);
				case Files : Assets.tiles.h_get("iconFile", inventoryFlow);
				case Photocopy : Assets.tiles.h_get("iconPhotocopy", inventoryFlow);
			}
			sprItems.push(spr);
		}

		onResize();
	}

	override function update() {
		super.update();

		pool.update(game.tmod);
	}

	override function postUpdate() {
		super.postUpdate();

		if( invalidated ) {
			invalidated = false;
			render();
		}
	}
}
