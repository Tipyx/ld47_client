package ui;

class ActionPopup extends h2d.Layers {

	public var wid(default, null) : Int = 75;
	public var hei(default, null) : Int = 40;
	
	public function new(str:String, onClick:Void->Void) {
		super();

		var bg = new h2d.Bitmap(h2d.Tile.fromColor(0x403b6d, wid, hei), this);

		var btn = new Button(Const.BUTTON_WIDTH >> 1, Const.BUTTON_HEIGHT >> 1, str, onClick);
		// var btn = new Button(str, onClick);
		this.addChild(btn);

		btn.setPosition((wid - btn.wid) >> 1, (hei - btn.hei) >> 1);
	}

}