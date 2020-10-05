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

	var cm : dn.Cinematic;

	public var controlLocked(default, null) : Bool;

	public function new(lvlInfo:Data.LevelInfo) {
		super(Game.ME);

		this.lvlInfo = lvlInfo;

		cm = new dn.Cinematic(Const.FPS);

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
		var tilesetTile = hxd.Res.atlas.tileset.toTile();

		for (at in lvlData.l_Collisions.autoTiles) {
			// Get corresponding H2D.Tile from tileset
			var tile = collisionLayer.tileset.getAutoLayerHeapsTile(tilesetTile, at);

			// Display it
			var bitmap = new h2d.Bitmap(tile);
			root.add(bitmap, Const.DP_BG);
			bitmap.x = at.renderX; // we use the auto-generated coords directly, because it's easier :)
			bitmap.y = at.renderY;
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

		if (entityLayer.all_Cupboard != null)
			for (c in entityLayer.all_Cupboard) {
				new en.Cupboard(c.cx, c.cy);
			}

		if (entityLayer.all_Bin != null)
			for (b in entityLayer.all_Bin) {
				new en.Bin(b.cx, b.cy);
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

		delayer.addF(()->game.scroller.ysort(Const.DP_MAIN), 1);

		currentTU = 0;

		arRequestPopups = [];
		arActionPopups = [];

		controlLocked = true;
	}

	public function start() {
		game.camera.trackTarget(player, true);
		game.hud.invalidate();

		game.scroller.y -= h();
		cm.create({
			tw.createS(game.scroller.y, game.scroller.y + h(), 0.5).end(()->cm.signal());
			end;
			game.hud.show();
			500;
			controlLocked = false;
		});
	}

	public inline function getLevelNumber() {
		var idLevel = Std.string(lvlInfo.ID);
		var splitId = idLevel.split("_");
		return Std.parseInt(splitId[1]);
	}

	public function onClickEntity(entity:Entity) {
		if (!entitiesAreNearEachOther(player, entity) || controlLocked)
			return;

		player.lookAt(entity.cx, entity.cy);

		var actions : Array<{str:String, onClick:ui.ActionPopup->Void, isEnable:Bool}> = [];
		if (entity.is(en.CoffeeMaker)) {
			actions.push({	str:"Take Coffee",
							isEnable:!player.inventoryIsFull,
							onClick:function(ap){
								ap.hide();
								if (!player.inventoryIsFull) {
									player.addToInventory(Coffee);
									new dn.heaps.Sfx(hxd.Res.sfx.coffeeGrinder).playOnGroup(VolumeGroup.CoffeeGrinder.getIndex());
									startNewTurn();
									endNewTurn();
								}
								else {
									game.hud.fxInventoryFull();
									game.showPopup("You can't hold anything anymore!");
								}
							}
			});
		}
		if (entity.is(en.Bin)) {
			var coffee = player.getCoffee();
			actions.push({	str:"Throw Coffee",
							isEnable:coffee != null,
							onClick:function(ap){
								ap.hide();
								if (coffee != null) {
									player.removeObject(coffee);
									new dn.heaps.Sfx(hxd.Res.sfx.splash).playOnGroup(VolumeGroup.Splash.getIndex());
									startNewTurn();
									endNewTurn();
								}
								else {
									game.hud.fxInventoryFull();
									game.showPopup("You don't have any coffee to be throw!");
								}
							}
			});
		}
		else if (entity.is(en.Cupboard)) {
			var files = player.getFileToPutAway();
			actions.push({	str:"Put Files Away",
							isEnable:files != null,
							onClick:function(ap){
								ap.hide();
								if (files != null) {
									player.removeObject(files);
									files.linkedEmployee.completeRequestType(PutFilesAway);
									new dn.heaps.Sfx(hxd.Res.sfx.cupboard).playOnGroup(VolumeGroup.Cupboard.getIndex());
									startNewTurn();
									endNewTurn();
								}
								else {
									game.hud.fxInventoryFull();
									game.showPopup("You don't have any files to be put away!");
								}
							}
			});
		}
		else if (entity.is(en.Copier)) {
			var files = player.getFileToCopy();
			actions.push({	str:"Do Copy",
							isEnable:files != null && !player.inventoryIsFull,
							onClick:function(ap){
								ap.hide();
								if (files == null) {
									game.hud.fxInventoryFull();
									game.showPopup("You don't have any file to photocopy!");
								}
								else if (!player.inventoryIsFull) {
									player.addToInventory(Photocopy, files.linkedEmployee);
									files.linkedEmployee = null;
									new dn.heaps.Sfx(hxd.Res.sfx.photocopy).playOnGroup(VolumeGroup.Photocopy.getIndex());
									startNewTurn();
									endNewTurn();
								}
								else {
									game.hud.fxInventoryFull();
									game.showPopup("You can't hold anything anymore!");
								}
							}
			});
		}
		else if (entity.is(en.File)) {
			var files = player.getFileToBeGiven();
			if (entity.as(en.File).isThere) {
				actions.push({	str:"Take Files",
								isEnable:!player.inventoryIsFull,
								onClick:function(ap){
									ap.hide();
									if (!player.inventoryIsFull) {
										player.addToInventory(Files, entity.as(en.File).linkedEmployee);
										entity.destroy();
										startNewTurn();
										endNewTurn();
									}
									else {
										game.hud.fxInventoryFull();
										game.showPopup("You can't hold anything anymore!");
									}
								}
				});
			}
			else if (files != null) {
				actions.push({	str:"Give Files",
								isEnable:true,
								onClick:function(ap){
									ap.hide();
									player.removeObject(files);
									entity.as(en.File).isGivenToEmployee();
									startNewTurn();
									endNewTurn();
								}
				});
			}
		}
		else if (entity.is(en.Employee)) {
			var emp = entity.as(en.Employee);
			var coffee = player.getCoffee();
			if (emp.hasRequest(NeedCoffee)) {
				actions.push({	str:"Give Coffee",
								isEnable: coffee != null,
								onClick:function(ap){
									ap.hide();
									if (coffee != null) {
										player.giveItemTo(coffee, emp);
										startNewTurn();
										endNewTurn();
									}
									else {
										game.hud.fxInventoryFull();
										game.showPopup("You don't have a coffee!");
									}
								}
				});
			}
			var photocopies = player.getPhotocopyToBeGivenTo(emp);
			if (emp.hasRequest(NeedPhotocopies)) {
				actions.push({	str:"Give Photocopies",
								isEnable:photocopies != null && photocopies.linkedEmployee == emp,
								onClick:function(ap){
									ap.hide();
									if (photocopies == null) {
										game.hud.fxInventoryFull();
										game.showPopup("You don't have the photocopies");
									}
									else if (photocopies != null && photocopies.linkedEmployee != emp) {
										game.hud.fxInventoryFull();
										game.showPopup("You don't have the good photocopies");
									}
									else
										player.giveItemTo(photocopies, emp);
										startNewTurn();
										endNewTurn();
								}
				});

			}
			emp.lookAtPlayer();
		}
		if (actions.length > 0)
			showActionPopup(entity, actions);
	}

	function showActionPopup(entity:Entity, actions:Array<{str:String, onClick:ui.ActionPopup->Void, isEnable:Bool}>) {
		var ap = new ui.ActionPopup(entity, actions);
		game.scroller.add(ap, Const.DP_UI);
		arActionPopups.push(ap);
	}

	public function showRequestPopup(entity:Entity, request:PendingRequest) {
		fx.newRequest(entity);
		var rp = new ui.RequestPopup(entity, request);
		game.scroller.add(rp, Const.DP_UI);
		arRequestPopups.push(rp);

		Assets.PLAY_NEWREQUEST_SFX();
	}

	public function removeRequestPopup(pr:PendingRequest) {
		for (popup in arRequestPopups) {
			if (pr == popup.request) {
				arRequestPopups.remove(popup);
				popup.remove();
				break;
			}
		}
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

		game.scroller.ysort(Const.DP_MAIN);

		game.hud.invalidate();

		checkEnd();
	}

	public function checkEnd() {
		var allRequestsCompleted = true;
		for (employee in arEmployee) {
			if (!employee.isCompleted()) {
				allRequestsCompleted = false;
				break;
			}
		}

		if (currentTU == lvlInfo.maximumScore || allRequestsCompleted) {
			controlLocked = true;

			cm.create({
				game.hud.hide();
				500;
				tw.createS(game.scroller.y, game.scroller.y + h(), 0.5).end(()->cm.signal());
				end;
				game.showEndLevel(allRequestsCompleted);
			});
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

	override function update() {
		super.update();

		cm.update(tmod);
	}

	override function postUpdate() {
		super.postUpdate();

		for (rp in arRequestPopups) {
			rp.postUpdate();
		}

	}
}