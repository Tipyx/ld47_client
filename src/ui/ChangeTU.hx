package ui;

class ChangeTU extends h2d.Layers {
    
    public var wid(default, null) : Int = 40;
    public var hei(default, null) : Int = 40;
    
    var currentTU : Int;
    var numTUText : h2d.Text;

    public function new(numTU:Int) {
        super();

        currentTU = numTU;

        var rectTU = new h2d.Graphics(this);
        rectTU.lineStyle(1, 0);
        rectTU.drawRect(30, 0, 40, 40);
        
        numTUText = new h2d.Text(Assets.fontPixel, rectTU);
        updateTUText();

        var interMinusOne = new h2d.Interactive(26, 16, this);
        interMinusOne.backgroundColor = 0xFFFF00FF;
        interMinusOne.setPosition(2, 2);
        interMinusOne.onClick = (e)->retrieveNumber(1);

        var interMinusTen = new h2d.Interactive(26, 16, this);
        interMinusTen.backgroundColor = 0xFFFF00FF;
        interMinusTen.setPosition(2, 22);
        interMinusTen.onClick = (e)->retrieveNumber(10);

        var interPlusOne = new h2d.Interactive(26, 16, this);
        interPlusOne.backgroundColor = 0xFFFF00FF;
        interPlusOne.setPosition(72, 2);
        interPlusOne.onClick = (e)->addNumber(1);

        var interPlusTen = new h2d.Interactive(26, 16, this);
        interPlusTen.backgroundColor = 0xFFFF00FF;
        interPlusTen.setPosition(72, 22);
        interPlusTen.onClick = (e)->addNumber(10);
    }

    function addNumber (nb:Int) {
        currentTU += nb;

        updateTUText();
    }

    function retrieveNumber (nb:Int) {
        if (currentTU >= nb) currentTU -= nb;
        else currentTU = 0;

        updateTUText();
    }

    function updateTUText () {
        numTUText.text = '$currentTU';
        numTUText.setPosition(30 + wid/2-numTUText.textWidth/2, hei/2-numTUText.textHeight/2);
    }
}