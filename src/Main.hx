import ui.TitleScreen;
import ui.Notepad;
import Data;
import hxd.Key;

class Main extends dn.Process {
	public static var ME : Main;
	public var controller : dn.heaps.Controller;
	public var ca : dn.heaps.Controller.ControllerAccess;

	public function new(s:h2d.Scene) {
		super();
		ME = this;

		createRoot(s);
		
		Const.INIT();

		// Engine settings
		hxd.Timer.wantedFPS = Const.FPS;
		engine.backgroundColor = 0xff<<24|0x292524;
        #if( hl && !debug )
        engine.fullScreen = true;
        #end

		// Resources
		#if(hl && debug)
		hxd.Res.initLocal();
        #else
        hxd.Res.initEmbed();
        #end

        // Hot reloading
		#if debug
        hxd.res.Resource.LIVE_UPDATE = true;
        hxd.Res.data.watch(function() {
            delayer.cancelById("cdb");

            delayer.addS("cdb", function() {
            	Data.load( hxd.Res.data.entry.getBytes().toString() );
            	if( Game.ME!=null )
                    Game.ME.onCdbReload();
            }, 0.2);
        });
		#end

		// Assets & data init
		Assets.init();
		#if debug
		new ui.Console(Assets.fontPixel, s);
		#end
		Lang.init("en");
		Data.load( hxd.Res.data.entry.getText() );

		// Game controller
		controller = new dn.heaps.Controller(s);
		ca = controller.createAccess("main");
		controller.bind(AXIS_LEFT_X_NEG, Key.LEFT, Key.Q, Key.A);
		controller.bind(AXIS_LEFT_X_POS, Key.RIGHT, Key.D);
		controller.bind(AXIS_LEFT_Y_POS, Key.UP, Key.Z, Key.W);
		controller.bind(AXIS_LEFT_Y_NEG, Key.DOWN, Key.S);
		controller.bind(X, Key.SPACE);
		// controller.bind(A, Key.UP, Key.Z, Key.W);
		// controller.bind(B, Key.ENTER, Key.NUMPAD_ENTER);
		// controller.bind(SELECT, Key.R);
		// controller.bind(START, Key.N);

		// Start
		new dn.heaps.GameFocusHelper(Boot.ME.s2d, Assets.fontPixel);
		delayer.addF( startTitleScreen, 1 );
	}

	public function clean() {
		if( TitleScreen.ME!=null ) {
			TitleScreen.ME.destroy();
		}
		if( Game.ME!=null ) {
			Game.ME.destroy();
		}
	}

	public function startTitleScreen() {
		clean();
		new TitleScreen();
	}

	public function startGame(debug:Bool) {
		var levelsToDo = [];

		for (lvl in Data.LevelInfo.all) {
			if (lvl.isDebug == debug)
				levelsToDo.push(lvl);
		}

		if( Game.ME!=null ) {
			Game.ME.destroy();
			delayer.addF(function() {
				new Game(levelsToDo);
			}, 1);
		}
		else
			new Game(levelsToDo);
	}

	public function startNotepad() {
		if( Notepad.ME!=null ) {
			Notepad.ME.destroy();
			delayer.addF(function() {
				new Notepad();
			}, 1);
		}
		else
			new Notepad();
	}

	public function showDebugTita() {
		
	}

	/* public function showDebugTipyx() {
		clean();
		startGame(true);
	} */

	public function start() {
		clean();
		startGame(true);
	}

	override public function onResize() {
		// Auto scaling
		if( Const.AUTO_SCALE_TARGET_WID>0 )
			Const.SCALE = M.ceil( w()/Const.AUTO_SCALE_TARGET_WID );
		else if( Const.AUTO_SCALE_TARGET_HEI>0 )
			Const.SCALE = M.ceil( h()/Const.AUTO_SCALE_TARGET_HEI );
		
		super.onResize();
	}

    override function update() {
		Assets.tiles.tmod = tmod;
        super.update();
    }
}