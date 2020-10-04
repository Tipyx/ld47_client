class Level extends dn.Process {
	public var game(get,never) : Game; inline function get_game() return Game.ME;
	public var fx(get,never) : Fx; inline function get_fx() return Game.ME.fx;

	public var wid(get,never) : Int; inline function get_wid() return lvlData.l_Collisions.cWid;
	public var hei(get,never) : Int; inline function get_hei() return lvlData.l_Collisions.cHei;

	public var lvlData(default, null) : LedData.LedData_Level;
	public var lvlInfo(default, null) : Data.LevelInfo;

	public var player(default, null) : en.Player;

	public var pf(default, null) : dn.pathfinder.AStar<CPoint>;

	public var currentTU : Int;

	public var arEmployee : Array<en.Employee>;

	public var arActionPopups : Array<ui.ActionPopup>;
	var arRequestPopups : Array<ui.RequestPopup>;

	public function new(lvlInfo:Data.LevelInfo) {
		super(Game.ME);

		this.lvlInfo = lvlInfo;

		lvlData = Const.LED_DATA.resolveLevel(lvlInfo.ID.toString());
		if (lvlData == null)
			throw "There is no level in LED named " + lvlInfo.ID;

		createRootInLayers(Game.ME.scroller, Const.DP_BG);

		initLevel();
	}

	function initLevel() {
		// Draw Levels
		var collisionLayer = lvlData.l_Collisions;
		var entityLayer = lvlData.l_Entities;

		var g = new h2d.Graphics();
		root.add(g, Const.DP_BG);
		g.beginFill(Const.LED_DATA.bgColor_int);
		g.drawRect(0, 0, collisionLayer.cWid*collisionLayer.gridSize, collisionLayer.cHei*collisionLayer.gridSize);
		g.endFill();

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
		
		if (entityLayer.all_Copier != null)
			for (c in entityLayer.all_Copier) {
				new en.Copier(c.cx, c.cy);
			}

		arEmployee = [];
		if (entityLayer.all_Employee != null)
			for (e in entityLayer.all_Employee) {
				if (e.f_timing.length != e.f_request.length)
					throw "There is not the same number of timing and request for an employee";
				
				var em = new en.Employee(e.cx, e.cy, arEmployee.length);
				arEmployee.push(em);
				for (i in 0...e.f_timing.length) {
					em.addRequest(e.f_timing[i], e.f_request[i]);
				}

			}

		currentTU = 1;

		arRequestPopups = [];
		arActionPopups = [];

		delayer.addF(()->game.hud.invalidate, 1);
	}

	public function onClickEntity(entity:Entity) {
		var actions : Array<{str:String, onClick:ui.ActionPopup->Void}> = [];
		if (entity.is(en.CoffeeMaker) && entitiesAreNearEachOther(player, entity)) {
			actions.push({	str:"Take Coffee",
							onClick:function(ap){
								ap.hide();
								player.addToInventory(Coffee);
							}
			});
		}
		else if (entity.is(en.Copier) && entitiesAreNearEachOther(player, entity)) {
			if (player.hasInInventory(Files))
				actions.push({	str:"Do Copy",
								onClick:function(ap){
									ap.hide();
									player.removeObject(Files);
									player.addToInventory(Photocopy);
								}
				});
		}
		else if (entity.is(en.File) && entitiesAreNearEachOther(player, entity)) {
			if (entity.as(en.File).isThere) {
				actions.push({	str:"Take Files",
								onClick:function(ap){
									ap.hide();
									player.addToInventory(Files);
									entity.destroy();
								}
				});
			}
			else if (player.hasInInventory(Files)) {
				actions.push({	str:"Give Files",
								onClick:function(ap){
									ap.hide();
									player.removeObject(Files);
									entity.as(en.File).isGivenToEmployee();
								}
				});
			}
		}
		else if (entity.is(en.Employee) && entitiesAreNearEachOther(player, entity)) {
			var emp = entity.as(en.Employee);
			if (player.hasInInventory(Coffee) && emp.hasRequest(NeedCoffee)) {
				actions.push({	str:"Give Coffee",
								onClick:function(ap){
									ap.hide();
									player.giveItemTo(Coffee, emp);
								}
				});
			}
			/* if (emp.hasRequest(CopyFiles) && emp.hasInInventory(Files)) {
				actions.push({	str:"Take Files",
								onClick:function(ap){
									ap.hide();
									emp.giveItemToPlayer(Files);
								}
				});
			} */
			if (emp.hasRequest(CopyFiles) && player.hasInInventory(Photocopy)) {
				actions.push({	str:"Give Photocopies",
								onClick:function(ap){
									ap.hide();
									player.giveItemTo(Photocopy, emp);
								}
				});
			}
		}
		if (actions.length > 0)
			showActionPopup(entity, actions);
	}

	function showActionPopup(entity:Entity, actions:Array<{str:String, onClick:ui.ActionPopup->Void}>) {
		var ap = new ui.ActionPopup(entity, actions);
		game.scroller.add(ap, Const.DP_UI);
		arActionPopups.push(ap);
	}

	public function showRequestPopup(entity:Entity, request:PendingRequest) {
		var rp = new ui.RequestPopup(entity, request);
		game.scroller.add(rp, Const.DP_UI);
		arRequestPopups.push(rp);
	}

	public function removeRequestPopup(pr:PendingRequest) {
		for (popup in arRequestPopups) {
			if (pr == popup.request) {
				arRequestPopups.remove(popup);
				popup.remove();
				break;
			}
		}

		checkEnd();
	}

	public function startNewTurn() {
		for (popup in arActionPopups.copy()) {
			popup.startNewTurn();
		}
	}

	public function endNewTurn() {
		currentTU++;

		for (employee in arEmployee) {
			employee.onNewTurn();
		}

		for (popup in arRequestPopups.copy()) {
			popup.onNewTurn();
		}

		game.hud.invalidate();
	}

	function checkEnd() {
		var levelIsOver = true;
		for (employee in arEmployee) {
			if (!employee.isCompleted()) {
				levelIsOver = false;
				break;
			}
		}

		if (levelIsOver) {
			game.showEndLevel();
		}
	}

	public inline function hasCollisionAt(cx:Int, cy:Int, except:Entity = null) {
		return lvlData.l_Collisions.getName(cx, cy) == "Wall"
			|| hasDeskAt(cx, cy)
			|| hasEntityAt(cx, cy, except);
	}

	public inline function hasDeskAt(cx:Int, cy:Int) return lvlData.l_Collisions.getName(cx, cy) == "Desk";
	
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

	override function onDispose() {
		super.onDispose();

		for (entity in Entity.ALL) {
			entity.destroy();
		}

		for (rp in arRequestPopups) {
			rp.remove();
		}

		for (ap in arActionPopups) {
			ap.remove();
		}
	}

	override function postUpdate() {
		super.postUpdate();
	}
}