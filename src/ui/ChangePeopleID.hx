package ui;

class ChangePeopleID extends h2d.Layers {
    
    public var wid(default, null) : Int = 40;
    public var hei(default, null) : Int = 40;
    
    var currentID : Int;
    var idText : h2d.Text;

    public function new(id:Int) {
        super();

        currentID = id;

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
        currentID += nb;

        updateidText();
    }

    function retrieveNumber (nb:Int) {
        if (currentID >= nb) currentID -= nb;

        updateidText();
    }

    function updateidText () {
        idText.text = '$currentID';
        idText.setPosition(30 + wid/2-idText.textWidth/2, hei/2-idText.textHeight/2);
    }
}