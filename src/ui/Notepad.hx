package ui;

class Notepad extends dn.Process {
	public static var ME : Notepad;
    public static var WIDTH_BTN : Int = 94;
    public static var HEIGHT_BTN : Int = 40;

	public var level(get,never) : Level; inline function get_level() return Game.ME.level;
	
	public var wid(get,never) : Int; inline function get_wid() return Std.int(w() * 0.75 / Const.SCALE) - Const.NOTEPAD_SPACING;
	// public var hei(get,never) : Int; inline function get_hei() return lvlData.l_Collisions.cHei;

    var bg : h2d.Graphics;
    var flow : h2d.Flow;
    var nbPage : Int;
    var nbLignLastPage : Int;
    var currentPage : Int;
    var currentLign : Int;
    var numLignCurrentPage : Int;
    var maximumEntries : Int;

    var flowTitle : h2d.Flow;

    var flowBtn : h2d.Flow;
    var previousPageBtn : h2d.Graphics;
    var nextPageBtn : h2d.Graphics;
    var newLignBtn : h2d.Graphics;
	var arNotepadData : Array<NotepadData>;
	
	var isShown : Bool;

	public function new() {
        super(Game.ME);
        
		ME = this;
        
        currentPage = 0;
        currentLign = 0;
        numLignCurrentPage = 0;

        arNotepadData = Const.PLAYER_DATA.planningDatas.get(level.lvlData.identifier);
        // var maximumEntries = Const.PLAYER_DATA.maximumNotepadEntry;
        maximumEntries = 13;

		if (arNotepadData == null) arNotepadData = [];

        nbPage = 0;

        createRootInLayers(parent.root, Const.DP_NOTEPAD);
 
        bg = new h2d.Graphics(root);
        bg.beginFill(0xe9e8be);
        bg.drawRect(0, 0,
                    wid, ((h() / Const.SCALE)));

        flowBtn = new h2d.Flow(root);
        flowBtn.layout = Horizontal;
        
        previousPageBtn = new h2d.Graphics(flowBtn);
        previousPageBtn.beginFill(0x677179);
        previousPageBtn.drawRect(0, 0, 40, 20);
        var interPrevious = new h2d.Interactive(40, 20, previousPageBtn);
        interPrevious.onClick = (e)->showPage(currentPage-1);
        flowBtn.getProperties(previousPageBtn).horizontalAlign = Left;
        
        newLignBtn = new h2d.Graphics(flowBtn);
        newLignBtn.beginFill(0xAFAFAF);
        newLignBtn.drawRect(0, 0, 20, 20);
        var interNew = new h2d.Interactive(20, 20, newLignBtn);
        interNew.onClick = function(e) {
            if (numLignCurrentPage == Const.NB_LIGN_PER_PAGE) {
                showPage(currentPage+1);
                nbPage++;
                numLignCurrentPage = 0;
                addLign(numLignCurrentPage);
            }
            else addLign(numLignCurrentPage);
        };
        flowBtn.getProperties(newLignBtn).isAbsolute = true;

        nextPageBtn = new h2d.Graphics(flowBtn);
        nextPageBtn.beginFill(0x677179);
        nextPageBtn.drawRect(0, 0, 40, 20);
        var interNext = new h2d.Interactive(40, 20, nextPageBtn);
        interNext.onClick = (e)->showPage(currentPage+1);
        flowBtn.getProperties(nextPageBtn).horizontalAlign = Right;
        
        flowBtn.minHeight = 20;

		showPage(currentPage);
		
		isShown = false;

		onResize();
	}
	
	public function show() {
        isShown = true;
        tw.createS(root.y, root.y - h(), 0.3);
	}
	
	public function hide() {
        isShown = false;
        tw.createS(root.y, root.y + h(), 0.3);
	}

    function showPage(page:Int) {
        currentPage = page;

        if (flow == null) {
            flow = new h2d.Flow(root);
            flow.layout = Vertical;
            flow.verticalSpacing = 10;
            flow.minWidth = wid;
            flow.minHeight = Std.int((h() / Const.SCALE) - Const.NOTEPAD_SPACING / 2);
            flow.paddingHorizontal = 40;
            flow.paddingVertical = 20;
			flow.horizontalAlign = Middle;
            flowBtn.minWidth = flow.minWidth;
        }

        if (flow != null) {
            flow.removeChildren();
        }

        var title = new h2d.Text(Assets.fontPixel, flow);
        title.text = "PLANNING";

        flowTitle = new h2d.Flow(flow);
        flowTitle.layout = Horizontal;
        flowTitle.minWidth = flow.minWidth - 2*flow.paddingLeft;
        flowTitle.debug = true;

        var flowWhen = new h2d.Flow(flowTitle);
        flowWhen.minWidth = Notepad.WIDTH_BTN;
        flowWhen.horizontalAlign = Middle;
        var when = new h2d.Text(Assets.fontPixel, flowWhen);
        when.text = 'When';
        flowTitle.getProperties(flowWhen).horizontalAlign = Left;

        var flowWhat = new h2d.Flow(flowTitle);
        flowWhat.minWidth = flowWhen.minWidth;
        flowWhat.horizontalAlign = flowWhen.horizontalAlign;
        var what = new h2d.Text(Assets.fontPixel, flowWhat);
        what.text = 'What';
        flowTitle.getProperties(flowWhat).horizontalAlign = Middle;
        
        var flowWho = new h2d.Flow(flowTitle);
        flowWho.minWidth = flowWhen.minWidth;
        flowWho.horizontalAlign = flowWhen.horizontalAlign;
        var who = new h2d.Text(Assets.fontPixel, flowWho);
        who.text = 'Who';
        flowTitle.getProperties(flowWho).horizontalAlign = Right;

        previousPageBtn.visible = currentPage != 0;
        nextPageBtn.visible = currentPage < nbPage;

        for (i in 0...Const.NB_LIGN_PER_PAGE) {
            var notepadID = i+currentPage*Const.NB_LIGN_PER_PAGE;
            if (arNotepadData[notepadID] != null) {
                showLign(i);
            }
        }
    }

    function addLign (i:Int) {
        if (currentLign < maximumEntries) {
            currentLign++;
            numLignCurrentPage++;
            arNotepadData.push({tu: 0, actionType: NPActionType.createByIndex(0), peopleID: 0});

            showLign(i);
        }
    }

    function showLign(i:Int) {
        var flowLign = new h2d.Flow(flow);
            flowLign.layout = Horizontal;
            flowLign.minWidth = flowTitle.minWidth;
            
            var bg = new h2d.Bitmap(h2d.Tile.fromColor(i%2 == 0 ? 0xb0b0b0 : 0x737373, 1, 1), flowLign);
            flowLign.getProperties(bg).isAbsolute = true;

            var notepadID = i+currentPage*Const.NB_LIGN_PER_PAGE;

            var changeTU = new ChangeTU(arNotepadData[notepadID]);
            flowLign.addChild(changeTU);
            flowLign.getProperties(changeTU).horizontalAlign = Left;

            var changeActionTypeIcon = new ChangeActionTypeIcon(arNotepadData[notepadID]);
            flowLign.addChild(changeActionTypeIcon);
            flowLign.getProperties(changeActionTypeIcon).horizontalAlign = Middle;

            var changePeopleID = new ChangePeopleID(arNotepadData[notepadID]);
            flowLign.addChild(changePeopleID);
            flowLign.getProperties(changePeopleID).horizontalAlign = Right;
            
            flowLign.reflow();
            bg.scaleX = flowLign.outerWidth;
            bg.scaleY = flowLign.outerHeight;
    }

    override function onResize() {
        super.onResize();

        root.setScale(Const.SCALE);

        flow.reflow();
		// root.x = Const.NOTEPAD_SPACING;
		root.x = (w() - wid * root.scaleX) / 2;
        root.y = isShown ? Const.NOTEPAD_SPACING : h() + Const.NOTEPAD_SPACING;
		
        flowBtn.y = (h() / Const.SCALE) - (Const.NOTEPAD_SPACING / 2) - flowBtn.outerHeight - 5;
        newLignBtn.setPosition((flowBtn.outerWidth - 20) / 2, 0);
        // TODO : mettre la taille du bouton
    }
}