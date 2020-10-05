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
        flow.minWidth = 250;
        flow.horizontalAlign = Middle;

        var upgrade = new h2d.Text(Assets.fontPixel, flow);
        upgrade.setScale(Const.SCALE);
        upgrade.text = "UPGRADES";

        flow.addSpacing(20);

        flowInventory = new h2d.Flow(flow);
        flowInventory.layout = Horizontal;
        // flowInventory.horizontalSpacing = 40;
        flowInventory.verticalAlign = Middle;
        flowInventory.minWidth = flow.minWidth;

        currentInventory = new h2d.Text(Assets.fontPixel, flowInventory);
        currentInventory.text = 'Current Inventory Places : ${Const.PLAYER_DATA.maximumInventoryStorage}';
        flowInventory.getProperties(currentInventory).horizontalAlign = Left;

        var upgradeInventoryBtn = new Button("Upgrade", function() {
            Const.PLAYER_DATA.maximumInventoryStorage += 1;
            render();
        }, 50, 20);
        flowInventory.addChild(upgradeInventoryBtn);
        flowInventory.getProperties(upgradeInventoryBtn).horizontalAlign = Right;
                
        flowNotepad = new h2d.Flow(flow);
        flowNotepad.layout = Horizontal;
        // flowNotepad.horizontalSpacing = 40;
        flowNotepad.verticalAlign = Middle;
        flowNotepad.minWidth = flow.minWidth;

        currentNotepad = new h2d.Text(Assets.fontPixel, flowNotepad);
        currentNotepad.text = 'Current Notepad Ligns : ${Const.PLAYER_DATA.maximumNotepadEntry}';
        flowNotepad.getProperties(currentNotepad).horizontalAlign = Left;

        var upgradeNotepadBtn = new Button("Upgrade", function() {
            Const.PLAYER_DATA.maximumNotepadEntry += 1;
            render();
        }, 50, 20);
        flowNotepad.addChild(upgradeNotepadBtn);
        flowNotepad.getProperties(upgradeNotepadBtn).horizontalAlign = Right;

		onResize();
    }
    
    function render() {
        currentInventory.text = 'Current Inventory Places : ${Const.PLAYER_DATA.maximumInventoryStorage}';
        currentNotepad.text = 'Current Notepad Ligns : ${Const.PLAYER_DATA.maximumNotepadEntry}';
    }

	override function onResize() {
		super.onResize();

        root.setScale(Const.SCALE);
        
        flow.reflow();
        flow.setPosition(((w() / Const.SCALE) - flow.outerWidth) / 2, ((h() / Const.SCALE) - flow.outerHeight) / 2);
	}
}