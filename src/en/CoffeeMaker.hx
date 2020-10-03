package en;

class CoffeeMaker extends Entity {
	
	public function new(cx, cy) {
		super(cx, cy);

		xr = yr = 0.5;

		spr.set("fxCircle");
		spr.setCenterRatio(0.5, 0.5);
		spr.colorize(0x583018);
	}
}