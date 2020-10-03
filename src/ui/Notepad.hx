package ui;

class Notepad extends dn.Process {
    public static var ME : Notepad;

    var flow : h2d.Flow;

	public function new() {
        super(Main.ME);
        
        ME = this;

        createRootInLayers(Main.ME.root, Const.DP_UI);
 
        var bg = new h2d.Graphics(root);
        bg.beginFill(0xFFFFFF);
        bg.drawRect(0, 0,
                    ((w() / Const.SCALE) - Const.NOTEPAD_SPACING), ((h() / Const.SCALE)));

        flow = new h2d.Flow(root);
        flow.layout = Vertical;
        flow.verticalSpacing = 20;
        flow.minWidth = Std.int((w() / Const.SCALE) - Const.NOTEPAD_SPACING);
        flow.debug=true;

        var title = new h2d.Text(Assets.fontPixel, flow);
        title.text = "Planning";
        flow.getProperties(title).horizontalAlign = Middle;

        /* var flowFirstLign = new h2d.Flow(flow);
        flowFirstLign.layout = Horizontal;
        flowFirstLign.horizontalSpacing = 20;

        var firstLign = new h2d.Graphics(flowFirstLign);
        firstLign.beginFill(0x000000);
        firstLign.drawRect(Const.NOTEPAD_SPACING, Const.NOTEPAD_SPACING,
                        ((w() / Const.SCALE) - 4 * Const.NOTEPAD_SPACING), 100); */

        onResize();

        bg.y += h();

        tw.createS(bg.y, bg.y-h(), 0.4);
    }

    override function onResize() {
        super.onResize();

        root.setScale(Const.SCALE);

        flow.reflow();
        root.setPosition(Const.NOTEPAD_SPACING, Const.NOTEPAD_SPACING);
    }
}