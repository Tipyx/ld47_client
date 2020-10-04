package en;

class Employee extends Entity {

	var requestsToDo : Array<{tu:Int, request:RequestType}>;
	var pendingRequest : Array<PendingRequest>;

	public var id : Int;

	public var inventory(default, null) : Array<Object>;
	
	public function new(cx, cy, id:Int) {
		super(cx, cy);

		xr = 0.5;
		yr = 0.5;

		spr.set("employee", id);
		spr.setCenterRatio(0.5, 0.5);

		var inter = new h2d.Interactive(Const.GRID, Const.GRID, spr);
		inter.setPosition(-(Const.GRID >> 1), -(Const.GRID >> 1));
		// inter.backgroundColor = 0x55FF00FF;

		inter.onClick = (e)->level.onClickEntity(this);

		requestsToDo = [];
		pendingRequest = [];

		inventory = [];
	}

	public function addRequest(tu:Int, request:RequestType) {
		requestsToDo.push({tu:tu, request:request});
	}

	public function hasRequest(rt:RequestType) {
		for (pr in pendingRequest) {
			if (pr.type == rt)
				return true;
		}

		return false;
	}

	public function gotItem(object:Object) {
		switch (object.type) {
			case Coffee: completeRequestType(NeedCoffee);
			case Files: completeRequestType(NeedFiles);
			case Photocopy: completeRequestType(NeedPhotocopies);
		}
	}

	public function completeRequestType(rt:RequestType) {
		for (pr in pendingRequest) {
			if (pr.type == rt) {
				pendingRequest.remove(pr);
				level.removeRequestPopup(pr);
				return;
			}
		}
	}

	public function addToInventory(object:Object) {
		inventory.push(object);
		game.hud.invalidate();
	}

	/* public function giveItemToPlayer(object:Object) {
		if (inventory.remove(object)) {
			level.player.addToInventory(object, this);
		}
	} */

	public inline function isCompleted():Bool {
		return requestsToDo.length == 0 && pendingRequest.length == 0;
	}

	public function onNewTurn() {
		for (pr in pendingRequest) {
			pr.elapsedTU++;
		}

		for (rtd in requestsToDo.copy()) {
			if (rtd.tu == level.currentTU) {
				requestsToDo.remove(rtd);
				var pr = {elapsedTU: 0, type:rtd.request};
				pendingRequest.push(pr);
				switch rtd.request {
					case NeedCoffee :
					case NeedFiles : 
						if (level.hasDeskAt(cx + 1, cy - 1)) new File(cx + 1, cy - 1, false, this);
						else if (level.hasDeskAt(cx - 1, cy - 1)) new File(cx - 1, cy - 1, false, this);
					case NeedPhotocopies, PutFilesAway : 
						if (level.hasDeskAt(cx + 1, cy - 1)) new File(cx + 1, cy - 1, true, this);
						else if (level.hasDeskAt(cx - 1, cy - 1)) new File(cx - 1, cy - 1, true, this);
					
					// addToInventory(Files);
				}
				level.showRequestPopup(this, pr);
			}
		}
	}


}