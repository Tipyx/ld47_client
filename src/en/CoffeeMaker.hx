package en;

class CoffeeMaker extends Entity {
	
	public function new(cx, cy) {
		super(cx, cy);

		xr = 0.5;
		yr = 0.5;

		spr.set("fxCircle");
		spr.setCenterRatio(0.5, 0.5);
		spr.colorize(0x583018);

		var inter = new h2d.Interactive(Const.GRID, Const.GRID, spr);
		inter.setPosition(-(Const.GRID >> 1), -(Const.GRID >> 1));
		inter.backgroundColor = 0x55FF00FF;
	}
}