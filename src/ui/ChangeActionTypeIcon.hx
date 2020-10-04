package ui;

class ChangeActionTypeIcon extends h2d.Layers {
    
    public var wid(default, null) : Int = 40;
    public var hei(default, null) : Int = 40;
    
    var currentIconID : Int;
    var maxIconID : Int;
    var iconText : h2d.Text;

    var notepadData : NotepadData;

    public function new(notepadData:NotepadData) {
        super();

        this.notepadData = notepadData;
        currentIconID = notepadData.actionType.getIndex();
        maxIconID = ActionType.createAll().length - 1;

        var rectIcon = new h2d.Graphics(this);
        rectIcon.lineStyle(1, 0);
        rectIcon.drawRect(30, 0, 40, 40);
        
        iconText = new h2d.Text(Assets.fontPixel, rectIcon);
        updateIconText();

        var interMinus = new h2d.Interactive(24, 24, this);
        interMinus.backgroundColor = 0xFFFF00FF;
        interMinus.setPosition(3, 8);
        interMinus.onClick = (e)->retrieveNumber(1);

        var interPlus = new h2d.Interactive(24, 24, this);
        interPlus.backgroundColor = 0xFFFF00FF;
        interPlus.setPosition(73, 8);
        interPlus.onClick = (e)->addNumber(1);
    }

    function addNumber (nb:Int) {
        if (currentIconID < maxIconID) currentIconID += nb;
        notepadData.actionType = ActionType.createByIndex(currentIconID);

        updateIconText();
    }

    function retrieveNumber (nb:Int) {
        if (currentIconID >= nb) currentIconID -= nb;
        notepadData.actionType = ActionType.createByIndex(currentIconID);

        updateIconText();
    }

    function updateIconText () {
        iconText.text = '$currentIconID';
        iconText.setPosition(30 + wid/2-iconText.textWidth/2, hei/2-iconText.textHeight/2);
    }
}