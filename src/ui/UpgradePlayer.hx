package ui;

class UpgradePlayer extends dn.Process {
	public var game(get,never) : Game; inline function get_game() return Game.ME;
	public var level(get,never) : Level; inline function get_level() return Game.ME.level;

    var flow : h2d.Flow;
    var flowInventory : h2d.Flow;
    var flowNotepad : h2d.Flow;

    var currentInventory : h2d.Text;
    var currentNotepad : h2d.Text;

    public function new() {
        super(Game.ME);

        createRootInLayers(parent.root, Const.DP_UPGRADE);
        
        flow = new h2d.Flow(root);
        flow.layout = Vertical;
        flow.verticalSpacing = 20;

        var upgrade = new h2d.Text(Assets.fontPixel, flow);
        upgrade.setScale(Const.SCALE);
        upgrade.text = "UPGRADES";

        flowInventory = new h2d.Flow(flow);
        flowInventory.layout = Horizontal;
        flowInventory.horizontalSpacing = 40;
        flowInventory.verticalAlign = Middle;

        currentInventory = new h2d.Text(Assets.fontPixel, flowInventory);
        currentInventory.text = 'Current Inventory Places : ${Const.PLAYER_DATA.maximumInventoryStorage}';

        var upgradeInventoryBtn = new Button("Upgrade", function() {
            Const.PLAYER_DATA.maximumInventoryStorage += 1;
            render();
        }, 50, 20);
        flowInventory.addChild(upgradeInventoryBtn);
                
        flowNotepad = new h2d.Flow(flow);
        flowNotepad.layout = Horizontal;
        flowNotepad.horizontalSpacing = 40;
        flowNotepad.verticalAlign = Middle;

        currentNotepad = new h2d.Text(Assets.fontPixel, flowNotepad);
        currentNotepad.text = 'Current Notepad Ligns : ${Const.PLAYER_DATA.maximumNotepadEntry}';

        var upgradeNotepadBtn = new Button("Upgrade", function() {
            Const.PLAYER_DATA.maximumNotepadEntry += 1;
            render();
        }, 50, 20);
        flowNotepad.addChild(upgradeNotepadBtn);

		onResize();
    }
    
    function render() {
        currentInventory.text = 'Current Inventory Places : ${Const.PLAYER_DATA.maximumInventoryStorage}';
        currentNotepad.text = 'Current Notepad Ligns : ${Const.PLAYER_DATA.maximumNotepadEntry}';
    }

	override function onResize() {
		super.onResize();

		root.setScale(Const.SCALE);

	}
}