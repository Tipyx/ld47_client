package ui;

class ChangeTU extends h2d.Layers {
    
    public var wid(default, null) : Int = 40;
    public var hei(default, null) : Int = 40;
    
    var numTUText : h2d.Text;

    var notepadData : NotepadData;

    var flow : h2d.Flow;
    var flowMinus : h2d.Flow;
    var flowPlus : h2d.Flow;

    public function new(notepadData:NotepadData) {
        super();

        this.notepadData = notepadData;

        flow = new h2d.Flow(this);
        flow.layout = Horizontal;
        flow.verticalAlign = Middle;
        flow.horizontalAlign = Middle;
        flow.minWidth = Notepad.WIDTH_BTN;
        flow.minHeight = Notepad.HEIGHT_BTN;

        flowMinus = new h2d.Flow(flow);
        flowMinus.layout = Vertical;
        flowMinus.minHeight = flow.minHeight;

        var interMinusOne = new h2d.Interactive(24, 16, flowMinus);
        interMinusOne.backgroundColor = 0xFFFF00FF;
        interMinusOne.onClick = (e)->retrieveNumber(1);
        flowMinus.getProperties(interMinusOne).verticalAlign = Top;

        var interMinusTen = new h2d.Interactive(24, 16, flowMinus);
        interMinusTen.backgroundColor = 0xFFFF00FF;
        interMinusTen.onClick = (e)->retrieveNumber(10);
        flowMinus.getProperties(interMinusTen).verticalAlign = Bottom;

        flow.getProperties(flowMinus).horizontalAlign = Left;

        var rectTU = new h2d.Graphics(flow);
        rectTU.lineStyle(1, 0);
        rectTU.drawRect(0, 0, 40, 40);

        flow.getProperties(rectTU).horizontalAlign = Middle;
        
        numTUText = new h2d.Text(Assets.fontPixel, rectTU);
        updateTUText();

        flowPlus = new h2d.Flow(flow);
        flowPlus.layout = Vertical;
        flowPlus.minHeight = flow.minHeight;

        var interPlusOne = new h2d.Interactive(24, 16, flowPlus);
        interPlusOne.backgroundColor = 0xFFFF00FF;
        interPlusOne.onClick = (e)->addNumber(1);
        flowPlus.getProperties(interPlusOne).verticalAlign = Top;

        var interPlusTen = new h2d.Interactive(24, 16, flowPlus);
        interPlusTen.backgroundColor = 0xFFFF00FF;
        interPlusTen.onClick = (e)->addNumber(10);
        flowPlus.getProperties(interPlusTen).verticalAlign = Bottom;

        flow.getProperties(flowPlus).horizontalAlign = Right;
    }

    function addNumber (nb:Int) {
        notepadData.tu += nb;

        updateTUText();
    }

    function retrieveNumber (nb:Int) {
        if (notepadData.tu >= nb) notepadData.tu -= nb;
        else notepadData.tu = 0;

        updateTUText();
    }

    function updateTUText () {
        numTUText.text = '${notepadData.tu}';
        numTUText.setPosition(wid/2-numTUText.textWidth/2, hei/2-numTUText.textHeight/2);
    }
}