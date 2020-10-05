package ui;

class ChangePeopleID extends h2d.Layers {
    public var wid(default, null) : Int = 40;
    public var hei(default, null) : Int = 40;
    
    var currentPeopleID : Int;
    var maxIconID : Int;
    
    var notepadData : NotepadData;

    var flow : h2d.Flow;

    var spr : HSprite;

    public function new(notepadData:NotepadData) {
        super();

        this.notepadData = notepadData;
        maxIconID = 3;
        
        flow = new h2d.Flow(this);
        flow.layout = Horizontal;
        flow.verticalAlign = Middle;
        flow.horizontalAlign = Middle;
		flow.horizontalSpacing = 5;
        flow.minWidth = Notepad.WIDTH_BTN;
        flow.minHeight = Notepad.HEIGHT_BTN;

		flow.addChild(createButton("<", Std.int(flow.minHeight * 0.5), ()->retrieveNumber(1)));

        var rectID = new h2d.Graphics(flow);
        rectID.lineStyle(1, 0);
		rectID.beginFill(0xbdb99e);
        rectID.drawRect(0, 0, wid, hei);

        spr = new HSprite(Assets.tiles);
        rectID.addChild(spr);
		spr.colorAdd= new h3d.Vector();
        spr.set("employeeFront", notepadData.peopleID);
        spr.setCenterRatio(0.5, 0.5);

        updatePeopleIcon();
		
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
        if (notepadData.peopleID != maxIconID) notepadData.peopleID += nb;

        updatePeopleIcon();
    }

    function retrieveNumber (nb:Int) {
        if (notepadData.peopleID >= nb) notepadData.peopleID -= nb;

        updatePeopleIcon();
    }

    function updatePeopleIcon () {
        spr.set("employeeFront", notepadData.peopleID);
        spr.setPosition(wid/2, hei/2);
    }
}