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
		
		flowMinus.addChild(createButton("-1", Std.int(flowMinus.minHeight / 2), ()->retrieveNumber(1)));
		flowMinus.addChild(createButton("-10", Std.int(flowMinus.minHeight / 2), ()->retrieveNumber(10)));

		flow.getProperties(flowMinus).horizontalAlign = Left;
		
        var rectTU = new h2d.Graphics(flow);
		rectTU.lineStyle(1, 0);
		rectTU.beginFill(0xbdb99e);
        rectTU.drawRect(0, 0, wid, hei);

        flow.getProperties(rectTU).horizontalAlign = Middle;
        
        numTUText = new h2d.Text(Assets.fontExpress18, rectTU);
		numTUText.textColor = 0x292524;
        updateTUText();

        flowPlus = new h2d.Flow(flow);
        flowPlus.layout = Vertical;
		flowPlus.minHeight = flow.minHeight;

		flowPlus.addChild(createButton("+1", Std.int(flowPlus.minHeight / 2), ()->addNumber(1)));
		flowPlus.addChild(createButton("+10", Std.int(flowPlus.minHeight / 2), ()->addNumber(10)));

        flow.getProperties(flowPlus).horizontalAlign = Right;
	}
	
	function createButton(str:String, height:Int, cb:Void->Void):Flow {
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