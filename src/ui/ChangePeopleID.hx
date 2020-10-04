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
        flow.minWidth = Notepad.WIDTH_BTN;
        flow.minHeight = Notepad.HEIGHT_BTN;

        var interMinus = new h2d.Interactive(24, 24, flow);
        interMinus.backgroundColor = 0xFFFF00FF;
        interMinus.onClick = (e)->retrieveNumber(1);

        flow.getProperties(interMinus).horizontalAlign = Left;

        var rectID = new h2d.Graphics(flow);
        rectID.lineStyle(1, 0);
        rectID.drawRect(0, 0, 40, 40);
        flow.getProperties(rectID).horizontalAlign = Middle;

        spr = new HSprite(Assets.tiles);
        rectID.addChild(spr);
		spr.colorAdd= new h3d.Vector();
        spr.set("employee", notepadData.peopleID);
        spr.setCenterRatio(0.5, 0.5);

        updatePeopleIcon();

        var interPlus = new h2d.Interactive(24, 24, flow);
        interPlus.backgroundColor = 0xFFFF00FF;
        interPlus.onClick = (e)->addNumber(1);

        flow.getProperties(interPlus).horizontalAlign = Right;
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
        spr.set("employee", notepadData.peopleID);
        spr.setPosition(wid/2, hei/2);
    }
}