package ui;

class EndLevel extends dn.Process {
	public var game(get,never) : Game; inline function get_game() return Game.ME;
	public var level(get,never) : Level; inline function get_level() return Game.ME.level;

	var lvlData : LedData.LedData_Level;
	var lvlInfo : Data.LevelInfo;

	var flow : h2d.Flow;
	
	public function new() {
		super(Game.ME);

		lvlData = level.lvlData;
		lvlInfo = level.lvlInfo;

		createRootInLayers(parent.root, Const.DP_UI);

		flow = new h2d.Flow(root);
		flow.layout = Vertical;
		flow.verticalSpacing = 20;
		flow.horizontalAlign = Middle;

		var endLevel = new h2d.Text(Assets.fontPixel, flow);
		endLevel.text = "Your day is over...";
		endLevel.setScale(Const.SCALE);

		var flowScore = new h2d.Flow(flow);
		flowScore.layout = Horizontal;
		flowScore.horizontalSpacing = 20;

		var score = new h2d.Text(Assets.fontPixel, flowScore);
		score.text = 'Your score: ${level.currentTU}';

		var maximumScore = new h2d.Text(Assets.fontPixel, flowScore);
		maximumScore.text = 'Level maximum score: ${lvlInfo.maximumScore}';

		var btn = new Button("Retry", function() {
			game.retryLevel(lvlInfo);
			destroy();
		});
		flow.addChild(btn);
	
		if (!game.isLastLevel && level.currentTU <= lvlInfo.maximumScore) {
			var btn = new Button("Next Level", function() {
				game.nextLevel();
				destroy();
			});
			flow.addChild(btn);
		}

		onResize();
	}

	override function onResize() {
		super.onResize();

		root.setScale(Const.SCALE);

		flow.reflow();
		flow.setPosition(Std.int((w() / Const.SCALE) - flow.outerWidth) >> 1, Std.int((h() / Const.SCALE) - flow.outerHeight) >> 1);
	}
}