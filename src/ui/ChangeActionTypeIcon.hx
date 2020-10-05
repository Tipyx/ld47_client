package ui;

class ChangeActionTypeIcon extends h2d.Layers {
    
    public var wid(default, null) : Int = 40;
    public var hei(default, null) : Int = 40;
    
    var currentIconID : Int;
    var maxIconID : Int;
	// var iconText : h2d.Text;
	var icon : HSprite;

    var notepadData : NotepadData;

    var flow : h2d.Flow;

    public function new(notepadData:NotepadData) {
        super();

        this.notepadData = notepadData;

        currentIconID = notepadData.actionType.getIndex();
        maxIconID = RequestType.createAll().length - 1;

        flow = new h2d.Flow(this);
        flow.layout = Horizontal;
        flow.verticalAlign = Middle;
		flow.horizontalAlign = Middle;
		flow.horizontalSpacing = 5;
        flow.minWidth = Notepad.WIDTH_BTN;
        flow.minHeight = Notepad.HEIGHT_BTN;

		flow.addChild(createButton("<", Std.int(flow.minHeight * 0.5), ()->retrieveNumber(1)));

        var rectIcon = new h2d.Graphics(flow);
        rectIcon.lineStyle(1, 0);
		rectIcon.beginFill(0xbdb99e);
        rectIcon.drawRect(0, 0, wid, hei);

        flow.getProperties(rectIcon).horizontalAlign = Middle;
        
		icon = Assets.tiles.h_get(Assets.GET_ICON_FOR_REQUEST(RequestType.createByIndex(currentIconID)), rectIcon);
		icon.setCenterRatio(0.5, 0.5);
		icon.setScale(2);
        updateIcon();
		
		flow.addChild(createButton(">", Std.int(flow.minHeight * 0.5), ()->addNumber(1)));
	}
	
	function createButton(str:String, height:Int, cb:Void->Void):h2d.Flow {
		var minFlow = new h2d.Flow();
		minFlow.horizontalAlign = minFlow.verticalAlign = Middle;
		minFlow.minWidth = height;
		minFlow.minHeight = height;
		minFlow.enableInteractive = true;
		minFlow.interactive.cursor = Button;
		minFlow.interactive.onClick = (e)->cb();
		var bg = new h2d.Graphics(minFlow);
		minFlow.getProperties(bg).isAbsolute = true;
        var text = new h2d.Text(Assets.fontExpress9, minFlow);
		text.text = str;
		text.textColor = 0x292524;
		minFlow.reflow();
		bg.beginFill(0xFFF0E68C);
		bg.drawRoundedRect(0, 2, minFlow.outerWidth, minFlow.outerHeight - 4, 2);

		return minFlow;
	}

    function addNumber (nb:Int) {
        if (currentIconID < maxIconID) currentIconID += nb;
        notepadData.actionType = RequestType.createByIndex(currentIconID);

        updateIcon();
    }

    function retrieveNumber (nb:Int) {
        if (currentIconID >= nb) currentIconID -= nb;
        notepadData.actionType = RequestType.createByIndex(currentIconID);

        updateIcon();
    }

    function updateIcon () {
		icon.set(Assets.GET_ICON_FOR_REQUEST(RequestType.createByIndex(currentIconID)));
        icon.setPosition(wid/2, hei/2);
    }
}