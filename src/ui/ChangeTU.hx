package ui;

import h2d.Flow;

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

        var flowMinusOne = new h2d.Flow(flowMinus);
        flowMinusOne.minHeight = Std.int(flowMinus.minHeight / 2);
        var interMinusOne = new h2d.Interactive(24, 16, flowMinusOne);
        interMinusOne.backgroundColor = 0xFFF0E68C;
        interMinusOne.onClick = (e)->retrieveNumber(1);
        flowMinusOne.getProperties(interMinusOne).verticalAlign = Middle;
        var minusOne = new h2d.Text(Assets.fontPixel, interMinusOne);
        minusOne.text = '-1';
        minusOne.setPosition((interMinusOne.width - minusOne.textWidth) / 2, (interMinusOne.height - minusOne.textHeight) / 2);

        var flowMinusTen = new h2d.Flow(flowMinus);
        flowMinusTen.minHeight = Std.int(flowMinus.minHeight / 2);
        var interMinusTen = new h2d.Interactive(24, 16, flowMinusTen);
        interMinusTen.backgroundColor = 0xFFF0E68C;
        interMinusTen.onClick = (e)->retrieveNumber(10);
        flowMinusTen.getProperties(interMinusTen).verticalAlign = Middle;
        var minusTen = new h2d.Text(Assets.fontPixel, interMinusTen);
        minusTen.text = '-10';
        minusTen.setPosition((interMinusTen.width - minusTen.textWidth) / 2, (interMinusTen.height - minusTen.textHeight) / 2);

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

        var flowPlusOne = new h2d.Flow(flowPlus);
        flowPlusOne.minHeight = Std.int(flowPlus.minHeight / 2);
        var interPlusOne = new h2d.Interactive(24, 16, flowPlusOne);
        interPlusOne.backgroundColor = 0xFFF0E68C;
        interPlusOne.onClick = (e)->addNumber(1);
        flowPlusOne.getProperties(interPlusOne).verticalAlign = Middle;
        var plusOne = new h2d.Text(Assets.fontPixel, interPlusOne);
        plusOne.text = '+1';
        plusOne.setPosition((interPlusOne.width - plusOne.textWidth) / 2, (interPlusOne.height - plusOne.textHeight) / 2);

        var flowPlusTen = new h2d.Flow(flowPlus);
        flowPlusTen.minHeight = Std.int(flowPlus.minHeight / 2);
        var interPlusTen = new h2d.Interactive(24, 16, flowPlusTen);
        interPlusTen.backgroundColor = 0xFFF0E68C;
        interPlusTen.onClick = (e)->addNumber(10);
        flowPlusTen.getProperties(interPlusTen).verticalAlign = Middle;
        var plusTen = new h2d.Text(Assets.fontPixel, interPlusTen);
        plusTen.text = '+10';
        plusTen.setPosition((interPlusTen.width - plusTen.textWidth) / 2, (interPlusTen.height - plusTen.textHeight) / 2);

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