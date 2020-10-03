package ui;

class Button extends h2d.Layers {

	public var wid(default, null) : Int;
	public var hei(default, null) : Int;

	public function new(wid:Int = Const.BUTTON_WIDTH, hei:Int = Const.BUTTON_HEIGHT, str:String, onClick:Void->Void) {
		super();

		this.wid = wid;
		this.hei = hei;

		var button = new h2d.Graphics(this);
		button.beginFill(0xFF888888);
		button.drawRect(0, 0, wid, hei);

		var inter = new h2d.Interactive(wid, hei, this);
        // inter.backgroundColor = 0xFF888888;
		inter.onClick = (e)->onClick();

		var text = new h2d.Text(Assets.fontPixel, this);
		text.text = str;
		text.textAlign = Center;
		text.maxWidth = wid;
		text.setPosition(0, Std.int(((hei/2)-(text.textHeight/2))));
    }
}