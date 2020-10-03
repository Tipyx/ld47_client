package ui;

class Notepad extends dn.Process {
    public static var ME : Notepad;

    var bg : h2d.Graphics;
    var flow : h2d.Flow;
    var numLign : Int;
    var nbPage : Int;
    var nbLignLastPage : Int;
    var numLignLeft : Int;
    var currentPage : Int;

    var flowBtn : h2d.Flow;
    var previousPageBtn : h2d.Graphics;
    var nextPageBtn : h2d.Graphics;

	public function new(numLign:Int) {
        super(Main.ME);
        
        ME = this;
        this.numLign = numLign;

        nbPage = Std.int(numLign / Const.NB_LIGN_PER_PAGE) + 1;
        trace('${nbPage}');
        nbLignLastPage = numLign % Const.NB_LIGN_PER_PAGE;
        trace('${nbLignLastPage}');

        createRootInLayers(Main.ME.root, Const.DP_UI);
 
        bg = new h2d.Graphics(root);
        bg.beginFill(0xFFFFFF);
        bg.drawRect(0, 0,
                    ((w() / Const.SCALE) - Const.NOTEPAD_SPACING), ((h() / Const.SCALE)));

        flowBtn = new h2d.Flow(root);
        flowBtn.layout = Horizontal;
        
        previousPageBtn = new h2d.Graphics(flowBtn);
        previousPageBtn.beginFill(0x000000);
        previousPageBtn.drawRect(0, 0, 40, 40);
        flowBtn.getProperties(previousPageBtn).horizontalAlign = Left;
        var interPrevious = new h2d.Interactive(40, 40, previousPageBtn);
        interPrevious.onClick = (e)->showPage(currentPage-1);
        
        nextPageBtn = new h2d.Graphics(flowBtn);
        nextPageBtn.beginFill(0x000000);
        nextPageBtn.drawRect(0, 0, 40, 40);
        var interNext = new h2d.Interactive(40, 40, nextPageBtn);
        interNext.onClick = (e)->showPage(currentPage+1);
        flowBtn.getProperties(nextPageBtn).horizontalAlign = Right;

        showPage(1);

        // var ut1 : NotepadLign = {ut: 0, icone: Coffee, peopleID: 1};

        onResize();

        root.y += h();

        tw.createS(root.y, root.y-h(), 0.4);
    }

    function showPage(page:Int) {
        currentPage = page;

        if (flow == null) {
            flow = new h2d.Flow(root);
            flow.layout = Vertical;
            flow.verticalSpacing = 10;
            flow.minWidth = Std.int((w() / Const.SCALE) - Const.NOTEPAD_SPACING);
            flow.minHeight = Std.int((h() / Const.SCALE) - Const.NOTEPAD_SPACING / 2);
            flow.debug=true;
            flow.paddingHorizontal = 20;
            flow.paddingVertical = 20;
            flowBtn.minWidth = flow.minWidth;
        }

        if (flow != null) {
            flow.removeChildren();
        }

        var title = new h2d.Text(Assets.fontPixel, flow);
        title.text = "Planning";
        flow.getProperties(title).horizontalAlign = Middle;

        trace('${currentPage}');
        trace('${nbPage}');

        if (currentPage == nbPage) numLignLeft = nbLignLastPage;
        else numLignLeft = Const.NB_LIGN_PER_PAGE;

        trace('${numLignLeft}');

        for (i in 0...numLignLeft) {
            var flowLign = new h2d.Flow(flow);
            flowLign.layout = Horizontal;
            flowLign.horizontalSpacing = 125;

            var changeTU = new ChangeTU(0);
            flowLign.addChild(changeTU);

            var changeActionTypeIcon = new ChangeActionTypeIcon(0);
            flowLign.addChild(changeActionTypeIcon);

            var changePeopleID = new ChangePeopleID(0);
            flowLign.addChild(changePeopleID);
        }

        previousPageBtn.visible = currentPage != 1;
        nextPageBtn.visible = currentPage < nbPage;
    }

    override function onResize() {
        super.onResize();

        root.setScale(Const.SCALE);

        flow.reflow();
        root.setPosition(Const.NOTEPAD_SPACING, Const.NOTEPAD_SPACING);

        flowBtn.y = (h() / Const.SCALE) - (Const.NOTEPAD_SPACING / 2) - flowBtn.outerHeight - 5;
    }
}