package en;

class Player extends Entity {

	var currentPath : Array<CPoint> = null;
	var nextCPoint : CPoint = null;

	var speed = 0.1; // case per frame

	public var inventory(default, null) : Array<Object>;

	public var inventoryIsFull(get, never) : Bool; inline function get_inventoryIsFull() return inventory.length == Const.PLAYER_DATA.maximumInventoryStorage;

	public var isMoving(get, never) : Bool; inline function get_isMoving() return nextCPoint != null;

	public function new(cx:Int, cy:Int) {
		super(cx, cy);

		xr = 0.5;
		yr = 0.5;

		spr.set("playerFront");
		spr.setCenterRatio(0.5, 0.75);

		inventory = [];
	}

	public function addToInventory(object:ObjectType, from:Null<Employee> = null) {
		inventory.push({type: object, linkedEmployee: from});
		game.hud.invalidate();
		game.hud.fxNewItem();
	}

	public function removeObject(object:Object) {
		inventory.remove(object);
		game.hud.invalidate();
	}

	public function hasInInventory(ot:ObjectType):Bool {
		for (object in inventory) {
			if (object.type == ot)
				return true;
		}
		return false;
	}

	public function giveItemTo(object:Object, to:Employee) {
		if (inventory.remove(object)) {
			to.gotItem(object);
		}
		game.hud.invalidate();
	}

	public function getFileToPutAway():Null<Object> {
		for (object in inventory) {
			if (object.type == Files && object.linkedEmployee != null && object.linkedEmployee.hasRequest(PutFilesAway))
				return object;
		}

		return null;
	}

	public function getFileToCopy():Null<Object> {
		for (object in inventory) {
			if (object.type == Files && object.linkedEmployee != null && object.linkedEmployee.hasRequest(NeedPhotocopies))
				return object;
		}

		return null;
	}

	public function getFileToBeGiven():Null<Object> {
		for (object in inventory) {
			if (object.type == Files && object.linkedEmployee == null)
				return object;
		}

		return null;
	}

	public function getPhotocopyToBeGivenTo(emp:Employee):Null<Object> {
		for (object in inventory) {
			if (object.type == Photocopy && object.linkedEmployee == emp && object.linkedEmployee.hasRequest(NeedPhotocopies))
				return object;
		}

		return null;
	}

	public function getCoffee():Null<Object> {
		for (object in inventory)
			if (object.type == Coffee)
				return object;

		return null;
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
		level.endNewTurn();
	}

	public function lookAt(tx:Int, ty:Int) {
		if (tx == cx + 1)
			spr.set("playerSideRight");
		else if (tx == cx - 1)
			spr.set("playerSideLeft");
		else if (ty == cy + 1)
			spr.set("playerFront");
		else if (ty == cy - 1)
			spr.set("playerBack");
	}

	override function update() {
		if (game.ca.xPressed())
			level.paused ? game.hideNotepad() : game.showNotepad();

		if (!level.paused) {
			if (!isMoving) {
				if (game.ca.leftPressed() && !level.hasCollisionAt(cx - 1, cy))
					nextCPoint = new CPoint(cx - 1, cy);
				else if (game.ca.rightPressed() && !level.hasCollisionAt(cx + 1, cy))
					nextCPoint = new CPoint(cx + 1, cy);
				else if (game.ca.upPressed() && !level.hasCollisionAt(cx, cy - 1))
					nextCPoint = new CPoint(cx, cy - 1);
				else if (game.ca.downPressed() && !level.hasCollisionAt(cx, cy + 1))
					nextCPoint = new CPoint(cx, cy + 1);

				if (nextCPoint != null) {
					Assets.PLAY_STEP_SFX();
					lookAt(nextCPoint.cx, nextCPoint.cy);
					level.startNewTurn();
				}
			}

			if (isMoving) {
				if (distPxFree(nextCPoint.footX, nextCPoint.footY) < speed * Const.GRID * 2 * tmod) {
					nextCPoint = null;
					cancelVelocities();
					xr = yr = 0.5;
	
					if (currentPath == null || currentPath.length == 0) {
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
	
			if (currentPath != null && currentPath.length > 0 && nextCPoint == null) {
				nextCPoint = currentPath.shift();
			}
		}

		super.update();
	}

}