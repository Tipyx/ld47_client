package en;

class File extends Entity {

	public var isThere(default, null) : Bool;

	var linkedEmployee : Null<Employee> = null;
	
	public function new(cx, cy, isThere:Bool, ?linkedEmployee:Employee = null) {
		super(cx, cy);

		this.linkedEmployee = linkedEmployee;
		this.isThere = isThere;

		xr = 0.5;
		yr = 0.5;

		spr.set("fxCircle");
		spr.setCenterRatio(0.5, 0.5);
		spr.colorize(0xeeebdd, isThere ? 1 : 0.5);

		var inter = new h2d.Interactive(Const.GRID, Const.GRID, spr);
		inter.setPosition(-(Const.GRID >> 1), -(Const.GRID >> 1));

		inter.onClick = (e)->level.onClickEntity(this);
	}

	public function isGivenToEmployee() {
		linkedEmployee.removeRequestType(NeedFiles);
		destroy();
	}
}