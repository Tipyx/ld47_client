package en;

class Cupboard extends Entity {
	
	public function new(cx, cy) {
		super(cx, cy);

		xr = 0.5;
		yr = 0.8;

		spr.set("cupboard");
		spr.setCenterRatio(0.5, 1);

		var inter = new h2d.Interactive(Const.GRID, Const.GRID * 2, spr);
		inter.setPosition(-(Const.GRID >> 1), -inter.height);
		// inter.backgroundColor = 0x55FF00FF;

		inter.onClick = (e)->level.onClickEntity(this);
	}
}