package ui;

class UpgradePlayer extends dn.Process {
	public static var ME : UpgradePlayer;

	public var game(get,never) : Game; inline function get_game() return Game.ME;
	public var level(get,never) : Level; inline function get_level() return Game.ME.level;

    var flow : h2d.Flow;
    var flowInventory : h2d.Flow;
    var flowNotepad : h2d.Flow;

    var upgrade : h2d.Text;
    var currentPoints : h2d.Text;

    var currentInventory : h2d.Text;
    var upgradeInventoryBtn : Button;

    var currentNotepad : h2d.Text;
    var upgradeNotepadBtn : Button;
    
    var backBtn : Button;

    var controlLock(default, null) = false;

    var cinematic : dn.Cinematic;

    public function new() {
        super(Game.ME);

        ME = this;

        createRootInLayers(parent.root, Const.DP_UPGRADE);

        cinematic = new dn.Cinematic(Const.FPS);
        
        flow = new h2d.Flow(root);
        flow.layout = Vertical;
        flow.verticalSpacing = 20;
        flow.minWidth = 250;
        flow.horizontalAlign = Middle;

        upgrade = new h2d.Text(Assets.fontPixel, flow);
        upgrade.setScale(Const.SCALE);
        upgrade.text = "UPGRADES";

        flow.addSpacing(20);

        currentPoints = new h2d.Text(Assets.fontPixel, flow);
        currentPoints.text = 'Current Points : ${Const.PLAYER_DATA.xp}';
        flow.getProperties(currentPoints).horizontalAlign = Left;

        flow.addSpacing(20);

        flowInventory = new h2d.Flow(flow);
        flowInventory.layout = Horizontal;
        // flowInventory.horizontalSpacing = 40;
        flowInventory.verticalAlign = Middle;
        flowInventory.minWidth = flow.minWidth;

        currentInventory = new h2d.Text(Assets.fontPixel, flowInventory);
        currentInventory.text = 'Current Inventory Places : ${Const.PLAYER_DATA.maximumInventoryStorage}';
        flowInventory.getProperties(currentInventory).horizontalAlign = Left;

        upgradeInventoryBtn = new Button('Upgrade cost : ${Const.PLAYER_DATA.nextCostInventory}', function() {
            if (Const.PLAYER_DATA.xp >= Const.PLAYER_DATA.nextCostInventory) {
                Const.PLAYER_DATA.maximumInventoryStorage += 1;
                Const.PLAYER_DATA.xp -= Const.PLAYER_DATA.nextCostInventory;
                Const.PLAYER_DATA.nextCostInventory *= 2;
                render();
            }
        }, 60, 30);
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

        upgradeNotepadBtn = new Button('Upgrade cost : ${Const.PLAYER_DATA.nextCostNotepad}', function() {
            if (Const.PLAYER_DATA.xp >= Const.PLAYER_DATA.nextCostNotepad) {
                Const.PLAYER_DATA.maximumNotepadEntry += 1;
                Const.PLAYER_DATA.xp -= Const.PLAYER_DATA.nextCostNotepad;
                Const.PLAYER_DATA.nextCostNotepad *= 2;
                render();
            }
        }, 60, 30);
        flowNotepad.addChild(upgradeNotepadBtn);
        flowNotepad.getProperties(upgradeNotepadBtn).horizontalAlign = Right;

        flow.addSpacing(20);

        backBtn = new Button("Back", onClickBtn);
        flow.addChild(backBtn);

        onResize();
        currentPoints.x -= w() / Const.SCALE;
        currentInventory.x -= w() / Const.SCALE;
        currentNotepad.x -= w() / Const.SCALE;
        upgradeInventoryBtn.x += w() / Const.SCALE;
        upgradeNotepadBtn.x += w() / Const.SCALE;
        backBtn.y += h() / Const.SCALE;

        cinematic.create({
            tw.createS(upgrade.alpha, 0>1, 0.4).end(()->cinematic.signal());
            end;
            tw.createS(currentPoints.x, currentPoints.x + (w() / Const.SCALE), 0.4).end(()->cinematic.signal());
            200;
            tw.createS(currentInventory.x, currentInventory.x + (w() / Const.SCALE), 0.4);
            tw.createS(upgradeInventoryBtn.x, upgradeInventoryBtn.x - (w() / Const.SCALE), 0.4).end(()->cinematic.signal());
            200;
            tw.createS(currentNotepad.x, currentNotepad.x + (w() / Const.SCALE), 0.4);
            tw.createS(upgradeNotepadBtn.x, upgradeNotepadBtn.x - (w() / Const.SCALE), 0.4).end(()->cinematic.signal());
            200;
            tw.createS(backBtn.y, backBtn.y - (h() / Const.SCALE), 0.4);
        });
    }

    function onClickBtn() {
        if (controlLock) return;
        controlLock = true;
        cinematic.create({
            tw.createS(upgrade.alpha, 0, 0.4);
            tw.createS(currentPoints.x, currentPoints.x - (w() / Const.SCALE), 0.4);
            tw.createS(currentInventory.x, currentInventory.x - (w() / Const.SCALE), 0.4);
            tw.createS(upgradeInventoryBtn.x, upgradeInventoryBtn.x + (w() / Const.SCALE), 0.4);
            tw.createS(currentNotepad.x, currentNotepad.x - (w() / Const.SCALE), 0.4);
            tw.createS(upgradeNotepadBtn.x, upgradeNotepadBtn.x + (w() / Const.SCALE), 0.4);
            tw.createS(backBtn.y, backBtn.y + (h() / Const.SCALE), 0.4).end(()->cinematic.signal());
            end;
            Game.ME.returnToEndLevel();
        });
    }
    
    function render() {
        currentInventory.text = 'Current Inventory Places : ${Const.PLAYER_DATA.maximumInventoryStorage}';
        upgradeInventoryBtn.updateText('Upgrade cost : ${Const.PLAYER_DATA.nextCostInventory}');

        currentNotepad.text = 'Current Notepad Ligns : ${Const.PLAYER_DATA.maximumNotepadEntry}';
        upgradeNotepadBtn.updateText('Upgrade cost : ${Const.PLAYER_DATA.nextCostNotepad}');

        currentPoints.text = 'Current Points : ${Const.PLAYER_DATA.xp}';
    }

	override function onResize() {
		super.onResize();

        root.setScale(Const.SCALE);
        
        flow.reflow();
        flow.setPosition(((w() / Const.SCALE) - flow.outerWidth) / 2, ((h() / Const.SCALE) - flow.outerHeight) / 2);
    }
    
    override function update() {
        super.update();

        if (Const.PLAYER_DATA.maximumInventoryStorage >= 6) upgradeInventoryBtn.visible = false;
        cinematic.update(tmod);
    }
}