package ui;

class EndLevel extends dn.Process {
	public var game(get,never) : Game; inline function get_game() return Game.ME;
	public var level(get,never) : Level; inline function get_level() return Game.ME.level;
	
	public function new() {
		super(Game.ME);

		createRootInLayers(parent.root, Const.DP_UI);

		var flow = new h2d.Flow(root);
		flow.layout = Vertical;
		flow.verticalSpacing = 20;

		var endLevel = new h2d.Text(Assets.fontPixel, flow);
		endLevel.text = "Your day is over...";

		var btn = new Button("Retry", game.retryLevel);
		flow.addChild(btn);
		var btn = new Button("Next", game.nextLevel);
		flow.addChild(btn);
	}

}