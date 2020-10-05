package ui;

import dn.Cinematic;

class EndLevel extends dn.Process {
	public static var ME : EndLevel;

	public var game(get,never) : Game; inline function get_game() return Game.ME;
	public var level(get,never) : Level; inline function get_level() return Game.ME.level;

	var lvlData : LedData.LedData_Level;
	var lvlInfo : Data.LevelInfo;

	var flow : h2d.Flow;
	var endLevel : h2d.Text;
	var score : h2d.Text;
	var maximumScore : h2d.Text;
	var btn : Button;
	var upgradeBtn : Button;

	var controlLock(default, null) = false;
	
	var cinematic : dn.Cinematic;

	public function new(levelisSuccessed:Bool) {
		super(Game.ME);

		ME = this;

		lvlData = level.lvlData;
		lvlInfo = level.lvlInfo;

		createRootInLayers(parent.root, Const.DP_UI);

		cinematic = new dn.Cinematic(Const.FPS);

		flow = new h2d.Flow(root);
		flow.layout = Vertical;
		flow.verticalSpacing = 20;
		flow.horizontalAlign = Middle;

		endLevel = new h2d.Text(Assets.fontPixel, flow);
		endLevel.setScale(Const.SCALE);

		if (!levelisSuccessed) showRewindLevel();
		else showEndLevel();
	}

	function showEndLevel() {
		endLevel.text = "Your day is over!";

		flow.addSpacing(30);

		var flowScore = new h2d.Flow(flow);
		flowScore.layout = Horizontal;
		flowScore.horizontalSpacing = 20;

		score = new h2d.Text(Assets.fontPixel, flowScore);
		score.text = 'Your score: ${level.currentTU}';

		maximumScore = new h2d.Text(Assets.fontPixel, flowScore);
		maximumScore.text = 'Level maximum score: ${lvlInfo.maximumScore}';

		flow.addSpacing(30);

		btn = new Button("Next Level", hideEndLevel);
		flow.addChild(btn);

		onResize();

		score.x -= w() / Const.SCALE;
		maximumScore.x += w() / Const.SCALE;
		btn.y += h() / Const.SCALE;

		cinematic.create({
			tw.createS(endLevel.alpha, 0>1, 0.5).end(()->cinematic.signal());
			end;
			tw.createS(score.x, score.x + (w() / Const.SCALE), 0.5);
			tw.createS(maximumScore.x, maximumScore.x - (w() / Const.SCALE), 0.5).end(()->cinematic.signal());
			end;
			tw.createS(btn.y, btn.y - (h() / Const.SCALE), 0.5);
		});
	}

	function hideEndLevel() {
		if (controlLock) return;
		controlLock = true;
		cinematic.create({
			tw.createS(endLevel.alpha, 0, 0.5);
			tw.createS(score.x, score.x - (w() / Const.SCALE), 0.5);
			tw.createS(maximumScore.x, maximumScore.x + (w() / Const.SCALE), 0.5);
			tw.createS(btn.y, btn.y + (h() / Const.SCALE), 0.5).end(()->cinematic.signal());
			end;
			game.nextLevel();
			destroy();
		});
	}

	function showRewindLevel() {
		endLevel.text = "You ran out of time...";

		flow.addSpacing(20);

		upgradeBtn = new Button("Upgrades", hideRewindLevel.bind(false));
		flow.addChild(upgradeBtn);

		btn = new Button("Retry", hideRewindLevel.bind(true));
		flow.addChild(btn);

		onResize();

		btn.x -= w() / Const.SCALE;
		upgradeBtn.x += w() / Const.SCALE;

		transitionRewindLevelAppear();
	}

	function hideRewindLevel(isRetry:Bool) {
		if (controlLock) return;
		controlLock = true;
		cinematic.create({
			tw.createS(endLevel.alpha, 0, 0.5);
			tw.createS(upgradeBtn.x, upgradeBtn.x + (w() / Const.SCALE), 0.5);
			tw.createS(btn.x, btn.x - (w() / Const.SCALE), 0.5).end(()->cinematic.signal());
			end;
			if (isRetry) {
				game.retryLevel(lvlInfo);
				destroy();
			}
			else {
				Game.ME.startUpgradePlayer();
			}
		});
	}

	public function transitionRewindLevelAppear () {
		cinematic.create({
			tw.createS(endLevel.alpha, 0>1, 0.5).end(()->cinematic.signal());
			end;
			tw.createS(upgradeBtn.x, upgradeBtn.x - (w() / Const.SCALE), 0.5).end(()->cinematic.signal());
			end;
			tw.createS(btn.x, btn.x + (w() / Const.SCALE), 0.5);
		});
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