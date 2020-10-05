package ui;

class EndCampaign extends dn.Process {
    public var game(get,never) : Game; inline function get_game() return Game.ME;
	public var level(get,never) : Level; inline function get_level() return Game.ME.level;

    var flow : h2d.Flow;

    public function new() {
		super(Game.ME);

		createRootInLayers(parent.root, Const.DP_UI);

        flow = new h2d.Flow(root);
		flow.layout = Vertical;
		flow.verticalSpacing = 40;
		flow.horizontalAlign = Middle;
        
        var congrats = new h2d.Text(Assets.fontExpress18, flow);
		congrats.text = 'Congratulations!';
		
		var endCampaign = new h2d.Text(Assets.fontExpress9, flow);
		endCampaign.text = 'You finished the Campaign!';

		var endCampaign = new h2d.Text(Assets.fontExpress9, flow);
		endCampaign.text = '"Now I\'m ready for the real world!!"';

		flow.addSpacing(20);

        var menuBtn = new Button("Menu", Main.ME.startTitleScreen);
		flow.addChild(menuBtn);

		onResize();
	}

    override function onResize() {
		super.onResize();

        root.setScale(Const.SCALE);
        
        flow.reflow();
		flow.setPosition(Std.int((w() / Const.SCALE) - flow.outerWidth) >> 1, Std.int((h() / Const.SCALE) - flow.outerHeight) >> 1);
	}
}