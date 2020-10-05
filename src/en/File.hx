package en;

class File extends Entity {

	public var isThere(default, null) : Bool;

	public var linkedEmployee(default, null) : Null<Employee> = null;
	
	public function new(cx, cy, isThere:Bool, ?linkedEmployee:Employee = null) {
		super(cx, cy);

		this.linkedEmployee = linkedEmployee;
		this.isThere = isThere;

		xr = 0.5;
		yr = 0.5;

		spr.set("files");
		spr.setCenterRatio(0.5, 0.5);
		// spr.colorize(0xeeebdd, );
		spr.alpha = isThere ? 1 : 0.5;

		var inter = new h2d.Interactive(Const.GRID, Const.GRID, spr);
		inter.setPosition(-(Const.GRID >> 1), -(Const.GRID >> 1));

		inter.onClick = (e)->level.onClickEntity(this);

		level.tw.createS(spr.alpha, 0 > spr.alpha, 0.5);
	}

	override function update() {
		super.update();

		if (!cd.hasSetS("fx", 1)) {
			fx.showFile(this);
		}
	}

	public function isGivenToEmployee() {
		linkedEmployee.completeRequestType(NeedFiles);
		destroy();
	}
}