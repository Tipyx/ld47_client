package ui;

class EndLevel extends dn.Process {
	public var game(get,never) : Game; inline function get_game() return Game.ME;
	public var level(get,never) : Level; inline function get_level() return Game.ME.level;

	var lvlData : LedData.LedData_Level;
	var lvlInfo : Data.LevelInfo;

	var flow : h2d.Flow;
	var endLevel : h2d.Text;
	
	public function new(levelisSuccessed:Bool) {
		super(Game.ME);

		lvlData = level.lvlData;
		lvlInfo = level.lvlInfo;

		createRootInLayers(parent.root, Const.DP_UI);

		flow = new h2d.Flow(root);
		flow.layout = Vertical;
		flow.verticalSpacing = 20;
		flow.horizontalAlign = Middle;

		endLevel = new h2d.Text(Assets.fontPixel, flow);
		endLevel.setScale(Const.SCALE);

		if (!levelisSuccessed) showRewindLevel();
		else showEndLevel();

		onResize();
	}

	function showEndLevel() {
		endLevel.text = "Your day is over!";

		var flowScore = new h2d.Flow(flow);
		flowScore.layout = Horizontal;
		flowScore.horizontalSpacing = 20;

		var score = new h2d.Text(Assets.fontPixel, flowScore);
		score.text = 'Your score: ${level.currentTU}';

		var maximumScore = new h2d.Text(Assets.fontPixel, flowScore);
		maximumScore.text = 'Level maximum score: ${lvlInfo.maximumScore}';

		var btn = new Button("Next Level", function() {
			game.nextLevel();
			destroy();
		});
		flow.addChild(btn);
	}

	function showRewindLevel() {
		endLevel.text = "You ran out of time...";

		var btn = new Button("Retry", function() {
			game.retryLevel(lvlInfo);
			destroy();
		});
		flow.addChild(btn);
	}

	override function onResize() {
		super.onResize();

		root.setScale(Const.SCALE);

		flow.reflow();
		flow.setPosition(Std.int((w() / Const.SCALE) - flow.outerWidth) >> 1, Std.int((h() / Const.SCALE) - flow.outerHeight) >> 1);
	}
}