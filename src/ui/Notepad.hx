package ui;

class Notepad extends dn.Process {
	public static var ME : Notepad;
    public static var WIDTH_BTN : Int = 94;
    public static var HEIGHT_BTN : Int = 40;

	public var level(get,never) : Level; inline function get_level() return Game.ME.level;
	
	public var wid(get,never) : Int; inline function get_wid() return Std.int(bg.tile.width);
	// public var hei(get,never) : Int; inline function get_hei() return lvlData.l_Collisions.cHei;

	// var bg : h2d.Graphics;
	var bg : HSprite;
    var flow : h2d.Flow;
    var nbPage : Int;
    var nbLignLastPage : Int;
    var currentPage : Int;
    var numLignCurrentPage : Int;
    var maximumEntries : Int;

    var flowTitle : h2d.Flow;

    var flowBtn : h2d.Flow;
    var previousPageBtn : h2d.Graphics;
    var nextPageBtn : h2d.Graphics;
    var newLignBtn : Button;
	var arNotepadData : Array<NotepadData>;
	
	var isShown : Bool;

	public function new() {
        super(Game.ME);
        
		ME = this;
        
        currentPage = 0;

        arNotepadData = Const.PLAYER_DATA.planningDatas.get(level.lvlData.identifier);
        maximumEntries = Const.PLAYER_DATA.maximumNotepadEntry;
        // maximumEntries = 13;

		if (arNotepadData == null) arNotepadData = [];

        nbPage = Math.ceil((arNotepadData.length) / Const.NB_LIGN_PER_PAGE);

        createRootInLayers(parent.root, Const.DP_NOTEPAD);
 
		var shadowBg = Assets.tiles.h_get("shadowNotepad", root);
		shadowBg.setPos(10, 10);

		bg = Assets.tiles.h_get("bgNotepad", root);


        flowBtn = new h2d.Flow(root);
        flowBtn.layout = Horizontal;
        
        previousPageBtn = new h2d.Graphics(flowBtn);
        previousPageBtn.beginFill(0x677179);
        previousPageBtn.drawRect(0, 0, 40, 20);
        var interPrevious = new h2d.Interactive(40, 20, previousPageBtn);
        interPrevious.onClick = (e)->showPage(currentPage-1);
		flowBtn.getProperties(previousPageBtn).horizontalAlign = Left;
		
		newLignBtn = new Button("Add Lign", function() {
			    if (numLignCurrentPage == Const.NB_LIGN_PER_PAGE) {
			        showPage(currentPage+1);
			        addLign(numLignCurrentPage);
			    }
			    else addLign(numLignCurrentPage);
			}, Const.BUTTON_WIDTH >> 1, Const.BUTTON_HEIGHT >> 1);
		flowBtn.addChild(newLignBtn);
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
		
		Const.SAVE_PROGRESS();
	}

    function showPage(page:Int) {
		currentPage = page;
		
		numLignCurrentPage = 0;

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

        var title = new h2d.Text(Assets.fontExpress18, flow);
		title.text = "PLANNING";
		title.textColor = 0x292524;
		title.dropShadow = {dx: 0, dy:1, alpha: 1, color:0x8e8052};

        flowTitle = new h2d.Flow(flow);
        flowTitle.layout = Horizontal;
        flowTitle.minWidth = flow.minWidth - 2*flow.paddingLeft;
        // flowTitle.debug = true;

        var flowWhen = new h2d.Flow(flowTitle);
        flowWhen.minWidth = Notepad.WIDTH_BTN;
        flowWhen.horizontalAlign = Middle;
        var when = new h2d.Text(Assets.fontExpress9, flowWhen);
        when.text = 'When';
		when.textColor = 0x292524;
		when.dropShadow = {dx: 0, dy:1, alpha: 1, color:0x8e8052};
        flowTitle.getProperties(flowWhen).horizontalAlign = Left;

        var flowWhat = new h2d.Flow(flowTitle);
        flowWhat.minWidth = flowWhen.minWidth;
        flowWhat.horizontalAlign = flowWhen.horizontalAlign;
        var what = new h2d.Text(Assets.fontExpress9, flowWhat);
        what.text = 'What';
		what.textColor = 0x292524;
		what.dropShadow = {dx: 0, dy:1, alpha: 1, color:0x8e8052};
        flowTitle.getProperties(flowWhat).horizontalAlign = Middle;
        
        var flowWho = new h2d.Flow(flowTitle);
        flowWho.minWidth = flowWhen.minWidth;
        flowWho.horizontalAlign = flowWhen.horizontalAlign;
        var who = new h2d.Text(Assets.fontExpress9, flowWho);
        who.text = 'Who';
		who.textColor = 0x292524;
		who.dropShadow = {dx: 0, dy:1, alpha: 1, color:0x8e8052};
        flowTitle.getProperties(flowWho).horizontalAlign = Right;

        previousPageBtn.visible = currentPage != 0;
        nextPageBtn.visible = currentPage < nbPage - 1;

        for (i in 0...Const.NB_LIGN_PER_PAGE) {
            var notepadID = i+currentPage*Const.NB_LIGN_PER_PAGE;
            if (arNotepadData[notepadID] != null) {
                showLign(i);
            }
        }
    }

    function addLign(i:Int) {
        if (arNotepadData.length < maximumEntries) {
			arNotepadData.push({tu: 0, actionType: RequestType.createByIndex(0), peopleID: 0});
			
			Const.PLAYER_DATA.planningDatas.set(level.lvlData.identifier, arNotepadData);

			nbPage = Math.ceil((arNotepadData.length) / Const.NB_LIGN_PER_PAGE);

			if (arNotepadData.length == maximumEntries)
				newLignBtn.visible = false;

            showLign(i);
		}
    }
	
	function deleteLign(data:NotepadData) {
		arNotepadData.remove(data);
		Const.PLAYER_DATA.planningDatas.set(level.lvlData.identifier, arNotepadData);
		
		newLignBtn.visible = true;

		nbPage = Math.ceil((arNotepadData.length) / Const.NB_LIGN_PER_PAGE);
		
		numLignCurrentPage--;
		
		if (numLignCurrentPage == 0)
			showPage(hxd.Math.imax(0, currentPage - 1));
		else
			showPage(currentPage);
	}

    function showLign(i:Int) {
        var flowLign = new h2d.Flow(flow);
		flowLign.layout = Horizontal;
		flowLign.minWidth = flowTitle.minWidth;
		flowLign.padding = 5;
		
		var bg = new h2d.Graphics(flowLign);
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
		bg.beginFill(i%2 == 0 ? 0x8e8052 : 0x9e9970);
		bg.drawRoundedRect(0, 0, flowLign.outerWidth, flowLign.outerHeight, 4);

		var deleteBtn = new Button("X", deleteLign.bind(arNotepadData[notepadID]), 16, 16);
		deleteBtn.updateBGColor(0xa00808);
		flowLign.addChild(deleteBtn);
		flowLign.getProperties(deleteBtn).isAbsolute = true;
		deleteBtn.setPosition(flowLign.outerWidth - deleteBtn.wid * 0.5, -deleteBtn.hei * 0.5);

		numLignCurrentPage++;
	}

    override function onResize() {
        super.onResize();

        root.setScale(Const.SCALE);

        flow.reflow();
		root.x = (w() - wid * root.scaleX) / 2;
        root.y = isShown ? Const.NOTEPAD_SPACING : h() + Const.NOTEPAD_SPACING;
		
        flowBtn.y = (h() / Const.SCALE) - (Const.NOTEPAD_SPACING / 2) - flowBtn.outerHeight - 5;
        newLignBtn.setPosition((flowBtn.outerWidth - newLignBtn.wid) / 2, 0);
    }
}