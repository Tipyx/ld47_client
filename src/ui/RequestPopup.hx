package ui;

class RequestPopup extends h2d.Layers {
	public var level(get,never) : Level; inline function get_level() return Game.ME.level;

	public var wid(default, null) : Int = 25;
	public var hei(default, null) : Int = 30;

	// var elapsedTime : h2d.Text;
	// var typeText : h2d.Text;

	var linkedEntity : Entity;

	public var request(default, null) : PendingRequest;

	var randomId : Int;
	
	public function new(linkedEntity:Entity, request:PendingRequest) {
		super();

		this.linkedEntity = linkedEntity;
		this.request = request;

		randomId = Std.random(999999);

		var flow = new h2d.Flow(this);
		flow.horizontalSpacing = 3;
		flow.padding = 2;
		flow.verticalAlign = Middle;
		flow.layout = Horizontal;
		// flow.verticalSpacing = 3;
		// flow.padding = 2;
		// flow.horizontalAlign = Middle;
		// flow.layout = Vertical;
		
		// var bg = new h2d.Bitmap(h2d.Tile.fromColor(0xc2e996, 1, 1), flow);
		var bg = new h2d.Graphics(flow);
		flow.getProperties(bg).isAbsolute = true;
		
		// elapsedTime = new h2d.Text(Assets.fontPixel, flow);
		// elapsedTime.text = Std.string(request.elapsedTU);

		// typeText = new h2d.Text(Assets.fontPixel, flow);
		// typeText.text = Std.string(request.type).substr(0, 2);
		// typeText.text = Std.string(request.type);
		var iconRequest = Assets.tiles.h_get(Assets.GET_ICON_FOR_REQUEST(request.type), flow);

		flow.reflow();

		wid = flow.outerWidth;
		hei = flow.outerHeight;

		bg.beginFill(0xbdb99e);
		bg.drawRoundedRect(0, 0, wid, hei, 4);

		this.setPosition((linkedEntity.cx + 0.5) * Const.GRID - (wid >> 1), (linkedEntity.cy + 0.5 - 1) * Const.GRID - hei);

		level.tw.createS(this.alpha, 0 > 1, 0.2);
		this.y += 5;
		level.tw.createS(this.y, this.y - 5 , 0.2);
		
		level.cd.setS("fxBright" + randomId, 0.3);
	}

	public function onNewTurn() {
		// elapsedTime.text = Std.string(request.elapsedTU);
	}

	var rndSign = 1;

	public function postUpdate() {
		if (!level.cd.hasSetS("fxBright" + randomId, Lib.rnd(1, 2))) {
			level.fx.bright(this, rndSign);
			rndSign = -rndSign;
		}
	}

}