package ui;

import dn.Cinematic;

class TitleScreen extends dn.Process {

    public static var ME : TitleScreen;

    var flow : h2d.Flow;
	var title : h2d.Text;
	var titaBtn : Button;
    // var tipyxBtn : Button;
    var startBtn : Button;

    var controlLock(default, null) = false;
    
    var cinematic : dn.Cinematic;
 
    public function new() {
        super(Main.ME);

        createRoot();

        cinematic = new dn.Cinematic(Const.FPS);

        ME = this;
        
        flow = new h2d.Flow(root);
        flow.layout = Vertical;
        flow.horizontalAlign = Middle;
        flow.verticalSpacing = 20;

        title = new h2d.Text(Assets.fontPixel, flow);
        title.text = "The Perfect Day";
        title.setScale(Const.SCALE);

        flow.addSpacing(50);

        // tipyxBtn = new Button("Tipyx", onClickBtn);
        // flow.addChild(tipyxBtn);

        startBtn = new Button("Start", onClickBtn);
        flow.addChild(startBtn);

		#if debug
        var startDbgBtn = new Button("Start DEBUG", Main.ME.startGame.bind(true));
		flow.addChild(startDbgBtn);
		#end
        
        onResize();

        // tipyxBtn.x -= w() / Const.SCALE;
        startBtn.x -= w() / Const.SCALE;

        cinematic.create({
            tw.createS(title.alpha, 0>1, 0.5);
            // tw.createS(tipyxBtn.x, tipyxBtn.x + (w() / Const.SCALE), 0.45);
            tw.createS(startBtn.x, startBtn.x + (w() / Const.SCALE), 0.45);
        });
    }

    function onClickBtn() {
		if (controlLock) return;
		controlLock = true;
		cinematic.create({
            tw.createS(title.alpha, 0, 0.5);
            // tw.createS(tipyxBtn.x, tipyxBtn.x + (w() / Const.SCALE), 0.45).end(()->cinematic.signal());
            tw.createS(startBtn.x, startBtn.x + (w() / Const.SCALE), 0.45).end(()->cinematic.signal());
            end;
			Main.ME.startGame(false);
		});
	}

    override function onDispose() {
		super.onDispose();

		ME = null;
    }

    override function onResize() {
        super.onResize();

        root.setScale(Const.SCALE);
		
		flow.reflow();
		flow.setPosition(Std.int((w() / Const.SCALE) - flow.outerWidth) >> 1, Std.int((h() / Const.SCALE) - flow.outerHeight) >> 1);
    }

    override function update() {
		super.update();

		cinematic.update(tmod);
	}
}