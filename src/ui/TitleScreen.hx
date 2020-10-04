package ui;

class TitleScreen extends dn.Process {

    public static var ME : TitleScreen;

    var flow : h2d.Flow;
	var title : h2d.Text;
	var titaBtn : Button;
	var tipyxBtn : Button;
 
    public function new() {
        super(Main.ME);

        createRoot();

        ME = this;
        
        flow = new h2d.Flow(root);
        flow.layout = Vertical;
        flow.horizontalAlign = Middle;
        flow.verticalSpacing = 20;

        title = new h2d.Text(Assets.fontPixel, flow);
        title.text = "The Perfect Day";

        flow.addSpacing(50);

        tipyxBtn = new Button("Tipyx", Main.ME.showDebugTipyx);
        flow.addChild(tipyxBtn);
        
        onResize();
    }

    override function onResize() {
        super.onResize();

        root.setScale(Const.SCALE);
		
		flow.reflow();
		flow.setPosition(Std.int((w() / Const.SCALE) - flow.outerWidth) >> 1, Std.int((h() / Const.SCALE) - flow.outerHeight) >> 1);
    }
}