class Level extends dn.Process {
	public var game(get,never) : Game; inline function get_game() return Game.ME;
	public var fx(get,never) : Fx; inline function get_fx() return Game.ME.fx;

	public var wid(get,never) : Int; inline function get_wid() return lvlData.l_Collisions.cWid;
	public var hei(get,never) : Int; inline function get_hei() return lvlData.l_Collisions.cHei;

	var lvlData : LedData.LedData_Level;

	var player : Player;

	public function new(lvlData:LedData.LedData_Level) {
		super(Game.ME);

		this.lvlData = lvlData;

		createRootInLayers(Game.ME.scroller, Const.DP_BG);

		initLevel();
	}

	function initLevel() {
		// Draw Levels
		var collisionLayer = lvlData.l_Collisions;

		// Render background
		var g = new h2d.Graphics(root);
		g.beginFill(Const.LED_DATA.bgColor_int);
		g.drawRect(0, 0, collisionLayer.cWid*collisionLayer.gridSize, collisionLayer.cHei*collisionLayer.gridSize);
		g.endFill();

		// Display IntGrid layer
		for(cx in 0...collisionLayer.cWid)
		for(cy in 0...collisionLayer.cHei) {
			if( !collisionLayer.hasValue(cx,cy) )
				continue;

			var c = collisionLayer.getColorInt(cx,cy);
			g.lineStyle(1, 0, 0.5);
			g.beginFill(c);
			g.drawRect(cx*collisionLayer.gridSize, cy*collisionLayer.gridSize, collisionLayer.gridSize, collisionLayer.gridSize);
			if (collisionLayer.getName(cx, cy) == "Floor") {
				g.lineStyle(1);
			}
		}

		var pf = new dn.pathfinder.AStar((x, y)->new CPoint(x, y));
		pf.init(wid, hei, (x, y)->collisionLayer.getName(x, y) == "Wall");

		var inter = new h2d.Interactive(lvlData.pxWid, lvlData.pxHei, root);
		inter.onClick = function(e) {
			var tx = Std.int(e.relX / Const.GRID);
			var ty = Std.int(e.relY / Const.GRID);
			var path = pf.getPath(player.cx, player.cy, tx, ty);
			path.unshift(new CPoint(player.cx, player.cy));
			/* for (i in 0...path.length - 1) { // WITH DIAGONAL
				var cur = path[i];
				var next = path[i + 1];
				for (p in dn.Bresenham.getThinLine(cur.cx, cur.cy, next.cx, next.cy, true)) {
					fx.markerCase(p.x, p.y);
				}
			} */
			for (i in 0...path.length - 1) { // WITHOUT DIAGONAL
				var cur = path[i];
				var next = path[i + 1];
				var newPath : Array<CPoint> = [];
				var lastAddedToPath : CPoint = null;
				var bPath = dn.Bresenham.getThickLine(cur.cx, cur.cy, next.cx, next.cy, true);
				for (p in bPath) {
					if (lastAddedToPath == null || areNearEachOther(lastAddedToPath.cx, lastAddedToPath.cy, p.x, p.y) ) {
						lastAddedToPath = new CPoint(p.x, p.y);
						newPath.push(lastAddedToPath);
					}
				}
				for (p in newPath) {
					fx.markerCase(p.cx, p.cy);
				}
			}
		}

		// dn.pathfinder.AStar.__test();

		// Init Entities

		player = new Player(wid >> 1, hei >> 1);
	}
	
	inline function areNearEachOther(x1:Int, y1:Int, x2:Int, y2:Int):Bool {
		return ((x1 == x2 && (y1 == y2 + 1 || y1 == y2 - 1))
			||	(y1 == y2 && (x1 == x2 + 1 || x1 == x2 - 1)));
	}

	public inline function isValid(cx,cy) return cx>=0 && cx<wid && cy>=0 && cy<hei;
	public inline function coordId(cx,cy) return cx + cy*wid;

	override function postUpdate() {
		super.postUpdate();
	}
}