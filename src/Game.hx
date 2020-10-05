import ui.EndCampaign;
import ui.EndLevel;
import ui.UpgradePlayer;
import dn.Process;
import hxd.Key;

class Game extends Process {
	public static var ME : Game;

	public var ca : dn.heaps.Controller.ControllerAccess;
	public var fx : Fx;
	public var camera : Camera;
	public var scroller : h2d.Layers;
	public var level : Level;
	public var hud : ui.Hud;

	public var notepad : ui.Notepad;

	var levelsToDo : Array<Data.LevelInfo> = [];
	public var isLastLevel(get, null) : Bool; inline function get_isLastLevel() {
		return levelsToDo.length == 0;
	}

	public function new(levelsToDo:Array<Data.LevelInfo>) {
		super(Main.ME);
		ME = this;

		this.levelsToDo = levelsToDo;

		ca = Main.ME.controller.createAccess("game");
		ca.setLeftDeadZone(0.2);
		ca.setRightDeadZone(0.2);
		createRootInLayers(Main.ME.root, Const.DP_BG);

		scroller = new h2d.Layers();
		root.add(scroller, Const.DP_BG);
		scroller.filter = new h2d.filter.ColorMatrix(); // force rendering for pixel perfect

		goToLevel(levelsToDo.shift());

		Process.resizeAll();
		trace(Lang.t._("Game is ready."));
	}

	public function onCdbReload() {
	}

	override function onResize() {
		scroller.setScale(Const.SCALE);

		camera.onResize();
		
		super.onResize();
	}

	function goToLevel(lvlInfo:Data.LevelInfo) {
		level = new Level(lvlInfo);
		camera = new Camera();
		notepad = new ui.Notepad();
		fx = new Fx();
		hud = new ui.Hud();

		level.start();
	}

	public function showNotepad() {
		level.pause();
		notepad.show();
	}

	public function hideNotepad() {
		level.resume();
		notepad.hide();
	}

	public function showPopup(str:String) {
		new ui.Popup(str);
	}

	public function showEndLevel(levelisSuccessed:Bool) {
		Const.SAVE_PROGRESS();

		new ui.EndLevel(levelisSuccessed);

		level.destroy();
		hud.destroy();
	}

	public function retryLevel(lvlInfo:Data.LevelInfo) {
		goToLevel(lvlInfo);
	}

	public function nextLevel() {
		goToLevel(levelsToDo.shift());
	}

	public function startUpgradePlayer(levelisSucceed:Bool) {
		EndLevel.ME.root.visible = false;
		new UpgradePlayer(levelisSucceed);
	}

	public function returnToEndLevel (levelisSucceed:Bool) {
		EndLevel.ME.root.visible = true;
		if (levelisSucceed) EndLevel.ME.transitionGoodEndLevel();
		else EndLevel.ME.transitionBadEndLevel();
		if (UpgradePlayer != null) {
			UpgradePlayer.ME.destroy();
		}
	}

	function gc() {
		if( Entity.GC==null || Entity.GC.length==0 )
			return;

		for(e in Entity.GC)
			e.dispose();
		Entity.GC = [];
	}

	override function onDispose() {
		super.onDispose();

		fx.destroy();
		for(e in Entity.ALL)
			e.destroy();
		gc();
	}

	override function preUpdate() {
		super.preUpdate();

		for(e in Entity.ALL) if( !e.destroyed ) e.preUpdate();
	}

	override function postUpdate() {
		super.postUpdate();

		for(e in Entity.ALL) if( !e.destroyed ) e.postUpdate();
		gc();
	}

	override function fixedUpdate() {
		super.fixedUpdate();

		for(e in Entity.ALL) if( !e.destroyed ) e.fixedUpdate();
	}

	override function update() {
		super.update();

		for(e in Entity.ALL) if( !e.destroyed ) e.update();

		#if debug
		if( !ui.Console.ME.isActive() && !ui.Modal.hasAny() ) {
			#if hl
			// Exit
			if( ca.isKeyboardPressed(Key.ESCAPE) )
				if( !cd.hasSetS("exitWarn",3) )
					trace(Lang.t._("Press ESCAPE again to exit."));
				else
					hxd.System.exit();

				/* if( ca.isKeyboardPressed(Key.F1) ) {
					level.destroy();
					hud.destroy();
					new UpgradePlayer();
				} */

				if( ca.isKeyboardPressed(Key.F2) ) {
					level.destroy();
					hud.destroy();
					new EndCampaign();
				}

				if( ca.isKeyboardPressed(Key.F3) ) {
					camera.shakeS(0.5, 0.5);
					fx.newRequest(level.arEmployee[0]);
				}
			#end
			
			// Restart
			// if( ca.selectPressed() )
			// 	Main.ME.startGame();
		}
		#end
	}
}

