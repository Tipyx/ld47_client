class Player extends Entity {

	public function new(cx:Int, cy:Int) {
		super(cx, cy);

		spr.set("fxCircle");
		spr.colorize(0xFF0000);
	}

	public function goTo(tx:Int, ty:Int) {
		
	}

	override function update() {
		super.update();
	}

}