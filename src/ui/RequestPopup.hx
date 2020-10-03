package ui;

class RequestPopup extends h2d.Layers {

	public var wid(default, null) : Int = 25;
	public var hei(default, null) : Int = 30;

	var elapsedTime : h2d.Text;
	var typeText : h2d.Text;

	var request : PendingRequest;
	
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

		typeText = new h2d.Text(Assets.fontPixel, flow);
		typeText.text = Std.string(request.type).substr(0, 2);

		flow.reflow();
		flow.setPosition(Std.int(wid - flow.outerWidth) >> 1, Std.int(hei - flow.outerHeight) >> 1);

		bg.scaleX = flow.outerWidth;
		bg.scaleY = flow.outerHeight;
	}

	public function onNewTurn() {
		elapsedTime.text = Std.string(request.elapsedTU);
	}

}