package ui;

class ChangePeopleID extends h2d.Layers {
    
    public var wid(default, null) : Int = 40;
    public var hei(default, null) : Int = 40;
    
    var idText : h2d.Text;

    var notepadData : NotepadData;

    public function new(notepadData:NotepadData) {
        super();

        this.notepadData = notepadData;

        var rectID = new h2d.Graphics(this);
        rectID.lineStyle(1, 0);
        rectID.drawRect(30, 0, 40, 40);
        
        idText = new h2d.Text(Assets.fontPixel, rectID);
        updateidText();

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
        notepadData.peopleID += nb;

        updateidText();
    }

    function retrieveNumber (nb:Int) {
        if (notepadData.peopleID >= nb) notepadData.peopleID -= nb;

        updateidText();
    }

    function updateidText () {
        idText.text = '${notepadData.peopleID}';
        idText.setPosition(30 + wid/2-idText.textWidth/2, hei/2-idText.textHeight/2);
    }
}