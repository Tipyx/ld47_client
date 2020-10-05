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
        flow.verticalAlign = Middle;
        flow.horizontalAlign = Middle;
        flow.minWidth = Notepad.WIDTH_BTN;
        flow.minHeight = Notepad.HEIGHT_BTN;

        var interMinus = new h2d.Interactive(24, 24, flow);
        interMinus.backgroundColor = 0xFFF0E68C;
        interMinus.onClick = (e)->retrieveNumber(1);
        var minus = new h2d.Text(Assets.fontPixel, interMinus);
        minus.text = '<';
        minus.setPosition((interMinus.width - minus.textWidth) / 2, (interMinus.height - minus.textHeight) / 2);

        flow.getProperties(interMinus).horizontalAlign = Left;

        var rectIcon = new h2d.Graphics(flow);
        rectIcon.lineStyle(1, 0);
        rectIcon.drawRect(0, 0, 40, 40);

        flow.getProperties(rectIcon).horizontalAlign = Middle;
        
        iconText = new h2d.Text(Assets.fontPixel, rectIcon);
        updateIconText();

        var interPlus = new h2d.Interactive(24, 24, flow);
        interPlus.backgroundColor = 0xFFF0E68C;
        interPlus.onClick = (e)->addNumber(1);
        var plus = new h2d.Text(Assets.fontPixel, interPlus);
        plus.text = '>';
        plus.setPosition((interPlus.width - plus.textWidth) / 2, (interPlus.height - plus.textHeight) / 2);

        flow.getProperties(interPlus).horizontalAlign = Right;
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