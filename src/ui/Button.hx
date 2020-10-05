package ui;

import h2d.Text;

class Button extends h2d.Layers {

	public var wid(default, null) : Int;
	public var hei(default, null) : Int;

	var text : h2d.Text;

	var spr : HSprite;

	public function new(str:String, onClick:Void->Void, ?wid:Int = Const.BUTTON_WIDTH, ?hei:Int = Const.BUTTON_HEIGHT) {
		super();

		this.wid = wid;
		this.hei = hei;

		spr = Assets.tiles.h_get("pixel", this);
		spr.colorize(0xFF888888);
		spr.scaleX = wid;
		spr.scaleY = hei;

		var inter = new h2d.Interactive(wid, hei, this);
        // inter.backgroundColor = 0xFF888888;
		inter.onClick = (e)->onClick();

		text = new h2d.Text(Assets.fontPixel, this);
		text.text = str;
		text.textAlign = Center;
		text.maxWidth = wid;
		text.setPosition(0, Std.int(((hei/2)-(text.textHeight/2))));
	}

	public function updateBGColor(col:UInt) spr.colorize(col);

	public function updateText(str:String) {
		text.text = str;
	}
}