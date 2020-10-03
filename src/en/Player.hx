package en;

class Player extends Entity {

	var currentPath : Array<CPoint> = null;
	var nextCPoint : CPoint = null;

	var speed = 0.2; // case per frame

	public var isMoving(get, never) : Bool; inline function get_isMoving() return nextCPoint != null;

	public function new(cx:Int, cy:Int) {
		super(cx, cy);

		xr = 0.5;
		yr = 0.5;

		spr.set("fxCircle");
		spr.setCenterRatio(0.5, 0.5);
		spr.colorize(0xFF0000);
	}

	public function goTo(tx:Int, ty:Int) {
		level.pf.init(level.wid, level.hei, (x, y)->level.hasCollisionAt(x, y, this));

		currentPath = [];
		var tPath = level.pf.getPath(cx, cy, tx, ty);
		tPath.unshift(new CPoint(cx, cy, 0.5, 0.5));
		/* for (i in 0...path.length - 1) { // WITH DIAGONAL
			var cur = path[i];
			var next = path[i + 1];
			for (p in dn.Bresenham.getThinLine(cur.cx, cur.cy, next.cx, next.cy, true)) {
				fx.markerCase(p.x, p.y);
			}
		} */
		for (i in 0...tPath.length - 1) { // WITHOUT DIAGONAL
			var cur = tPath[i];
			var next = tPath[i + 1];
			var newPath : Array<CPoint> = [];
			var lastAddedToPath : CPoint = null;
			var bPath = dn.Bresenham.getThickLine(cur.cx, cur.cy, next.cx, next.cy, true);
			for (p in bPath) {
				if ((lastAddedToPath == null || level.areNearEachOther(lastAddedToPath.cx, lastAddedToPath.cy, p.x, p.y))
				&&	!level.hasCollisionAt(p.x, p.y, this)) {
					lastAddedToPath = new CPoint(p.x, p.y, 0.5, 0.5);
					newPath.push(lastAddedToPath);
				}
			}
			currentPath = currentPath.concat(newPath);
		}

		currentPath.shift();

		/* for (point in currentPath) {
			fx.markerCase(point.cx, point.cy);
		} */
	}

	function onReachEnd() {
		
	}

	override function update() {
		super.update();

		if (nextCPoint != null) {
			if (distPxFree(nextCPoint.footX, nextCPoint.footY) < speed * 3) {
				nextCPoint = null;
				cancelVelocities();
				xr = yr = 0.5;

				if (currentPath.length == 0) {
					onReachEnd();
					currentPath = null;
				}
			}
			else {
				var ang = M.angTo(this.footX, this.footY, nextCPoint.footX, nextCPoint.footY);
				dx = speed * Math.cos(ang);
				dy = speed * Math.sin(ang);
			}
		}

		while (currentPath != null && currentPath.length > 0 && nextCPoint == null) {
			nextCPoint = currentPath.shift();
		}
	}

}