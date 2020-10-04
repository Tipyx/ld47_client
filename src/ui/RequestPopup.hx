package ui;

class RequestPopup extends h2d.Layers {
	public var level(get,never) : Level; inline function get_level() return Game.ME.level;

	public var wid(default, null) : Int = 25;
	public var hei(default, null) : Int = 30;

	var elapsedTime : h2d.Text;
	// var typeText : h2d.Text;

	public var request(default, null) : PendingRequest;
	
	public function new(request:PendingRequest) {
		super();

		this.request = request;

		var flow = new h2d.Flow(this);
		flow.verticalSpacing = 3;
		flow.padding = 2;
		flow.horizontalAlign = Middle;
		flow.layout = Vertical;
		
		var bg = new h2d.Bitmap(h2d.Tile.fromColor(0xc2e996, 1, 1), flow);
		flow.getProperties(bg).isAbsolute = true;
		
		elapsedTime = new h2d.Text(Assets.fontPixel, flow);
		elapsedTime.text = Std.string(request.elapsedTU);

		// typeText = new h2d.Text(Assets.fontPixel, flow);
		// typeText.text = Std.string(request.type).substr(0, 2);
		// typeText.text = Std.string(request.type);
		var iconRequest = Assets.tiles.h_get(Assets.GET_ICON_FOR_REQUEST(request.type), flow);

		flow.reflow();

		bg.scaleX = wid = flow.outerWidth;
		bg.scaleY = hei = flow.outerHeight;
	}

	public function onNewTurn() {
		elapsedTime.text = Std.string(request.elapsedTU);
	}

}