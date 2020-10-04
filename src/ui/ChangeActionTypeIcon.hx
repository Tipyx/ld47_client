package ui;

class ChangeActionTypeIcon extends h2d.Layers {
    
    public var wid(default, null) : Int = 40;
    public var hei(default, null) : Int = 40;
    
    var currentIconID : Int;
    var maxIconID : Int;
    var iconText : h2d.Text;

    var notepadData : NotepadData;

    var flow : h2d.Flow;

    public function new(notepadData:NotepadData) {
        super();

        this.notepadData = notepadData;

        currentIconID = notepadData.actionType.getIndex();
        maxIconID = NPActionType.createAll().length - 1;

        flow = new h2d.Flow(this);
        flow.layout = Horizontal;
        flow.horizontalSpacing = 3;
        flow.verticalAlign = Middle;
        flow.horizontalAlign = Middle;

        var interMinus = new h2d.Interactive(24, 24, flow);
        interMinus.backgroundColor = 0xFFFF00FF;
        interMinus.onClick = (e)->retrieveNumber(1);

        var rectIcon = new h2d.Graphics(flow);
        rectIcon.lineStyle(1, 0);
        rectIcon.drawRect(0, 0, 40, 40);
        
        iconText = new h2d.Text(Assets.fontPixel, rectIcon);
        updateIconText();

        var interPlus = new h2d.Interactive(24, 24, flow);
        interPlus.backgroundColor = 0xFFFF00FF;
        interPlus.onClick = (e)->addNumber(1);

        trace(flow.outerWidth);
    }

    function addNumber (nb:Int) {
        if (currentIconID < maxIconID) currentIconID += nb;
        notepadData.actionType = NPActionType.createByIndex(currentIconID);

        updateIconText();
    }

    function retrieveNumber (nb:Int) {
        if (currentIconID >= nb) currentIconID -= nb;
        notepadData.actionType = NPActionType.createByIndex(currentIconID);

        updateIconText();
    }

    function updateIconText () {
        iconText.text = '$currentIconID';
        iconText.setPosition(wid/2-iconText.textWidth/2, hei/2-iconText.textHeight/2);
    }
}