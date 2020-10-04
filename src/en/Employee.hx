package en;

class Employee extends Entity {

	var requestsToDo : Array<{tu:Int, request:RequestType}>;
	var pendingRequest : Array<PendingRequest>;
	
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

		inter.onClick = (e)->level.onClickEntity(this);

		requestsToDo = [];
		pendingRequest = [];
	}

	public function addRequest(tu:Int, request:RequestType) {
		requestsToDo.push({tu:tu, request:request});
	}

	public function gotItem(object:ObjectType) {
		for (pr in pendingRequest) {
			if (pr.type == NeedCoffee && object == Coffee) {
				pendingRequest.remove(pr);
				level.removeRequestPopup(pr);
				return;
				// TODO : SCORE
			}
		}
	}

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
				level.showRequestPopup(this, pr);
			}
		}
	}


}