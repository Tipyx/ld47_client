class Level extends dn.Process {
	public var game(get,never) : Game; inline function get_game() return Game.ME;
	public var fx(get,never) : Fx; inline function get_fx() return Game.ME.fx;

	public var wid(get,never) : Int; inline function get_wid() return lvlData.l_Collisions.cWid;
	public var hei(get,never) : Int; inline function get_hei() return lvlData.l_Collisions.cHei;

	public var lvlData(default, null) : LedData.LedData_Level;

	var player : en.Player;

	public var pf(default, null) : dn.pathfinder.AStar<CPoint>;

	public function new(lvlData:LedData.LedData_Level) {
		super(Game.ME);

		this.lvlData = lvlData;

		createRootInLayers(Game.ME.scroller, Const.DP_BG);

		initLevel();
	}

	function initLevel() {
		// Draw Levels
		var collisionLayer = lvlData.l_Collisions;
		var entityLayer = lvlData.l_Entities;

		// Render background
		var g = new h2d.Graphics();
		root.add(g, Const.DP_BG);
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
				g.lineStyle(1, 0.25);
			}
		}

		pf = new dn.pathfinder.AStar((x, y)->new CPoint(x, y, 0.5, 0.5));

		var inter = new h2d.Interactive(lvlData.pxWid, lvlData.pxHei);
		root.add(inter, Const.DP_BG);
		inter.onClick = function(e) {
			/* if (player.isMoving)
				return;

			
			var tx = Std.int(e.relX / Const.GRID);
			var ty = Std.int(e.relY / Const.GRID);
			player.goTo(tx, ty); */
		}

		// Init Entities
		var playerData = entityLayer.all_Player[0];
		player = new en.Player(playerData.cx, playerData.cy);

		if (entityLayer.all_CoffeeMaker != null)
			for (cm in entityLayer.all_CoffeeMaker) {
				new en.CoffeeMaker(cm.cx, cm.cy);
			}
	}

	public function onClickEntity(entity:Entity) {
		if (entity.is(en.CoffeeMaker) && entitiesAreNearEachOther(player, entity)) {
			showActionPopup(entity, "Take Coffee", ()->null);
		}
	}

	function showActionPopup(entity:Entity, str:String, cb:Void->Void) {
		var ap = new ui.ActionPopup(str, cb);
		ap.setPosition(entity.headX - (ap.wid >> 1), entity.headY - ap.hei);
		root.add(ap, Const.DP_UI);
	}

	public inline function hasCollisionAt(cx:Int, cy:Int, except:Entity = null) {
		return lvlData.l_Collisions.getName(cx, cy) == "Wall" || hasEntityAt(cx, cy, except);
	}
	
	public function hasEntityAt(cx:Int, cy:Int, except:Entity = null) {
		for (entity in Entity.ALL) {
			if (entity.cx == cx && entity.cy == cy && (except == null || except != entity))
				return true;
		}

		return false;
	}
	
	public inline function areNearEachOther(x1:Int, y1:Int, x2:Int, y2:Int):Bool {
		return ((x1 == x2 && (y1 == y2 + 1 || y1 == y2 - 1))
			||	(y1 == y2 && (x1 == x2 + 1 || x1 == x2 - 1)));
	}

	public inline function entitiesAreNearEachOther(en1:Entity, en2:Entity):Bool {
		return areNearEachOther(en1.cx, en1.cy, en2.cx, en2.cy);
	}

	public inline function isValid(cx,cy) return cx>=0 && cx<wid && cy>=0 && cy<hei;
	public inline function coordId(cx,cy) return cx + cy*wid;

	override function postUpdate() {
		super.postUpdate();
	}
}