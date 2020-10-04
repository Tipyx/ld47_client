package ui;

class ChangePeopleID extends h2d.Layers {
    
    public var wid(default, null) : Int = 40;
    public var hei(default, null) : Int = 40;
    
    var idText : h2d.Text;

    var notepadData : NotepadData;

    var flow : h2d.Flow;

    public function new(notepadData:NotepadData) {
        super();

        this.notepadData = notepadData;

        flow = new h2d.Flow(this);
        flow.layout = Horizontal;
        flow.horizontalSpacing = 3;
        flow.verticalAlign = Middle;
        // flow.horizontalAlign = Middle;

        var interMinus = new h2d.Interactive(24, 24, flow);
        interMinus.backgroundColor = 0xFFFF00FF;
        interMinus.onClick = (e)->retrieveNumber(1);

        var rectID = new h2d.Graphics(flow);
        rectID.lineStyle(1, 0);
        rectID.drawRect(0, 0, 40, 40);
        
        idText = new h2d.Text(Assets.fontPixel, rectID);
        updateidText();

        var interPlus = new h2d.Interactive(24, 24, flow);
        interPlus.backgroundColor = 0xFFFF00FF;
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
        idText.setPosition(wid/2-idText.textWidth/2, hei/2-idText.textHeight/2);
    }
}