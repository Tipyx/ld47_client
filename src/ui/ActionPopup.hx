package ui;

class ActionPopup extends h2d.Layers {
	public var level(get,never) : Level; inline function get_level() return Game.ME.level;

	public var wid(default, null) : Int = 75;
	public var hei(default, null) : Int = 40;

	var linkedEntity : Entity;
	
	public function new(linkedEntity:Entity, actions:Array<{str:String, onClick:ActionPopup->Void, isEnable:Bool}>) {
		super();

		this.linkedEntity = linkedEntity;

		var flow = new h2d.Flow(this);
		flow.verticalSpacing = 3;
		flow.padding = 2;
		flow.horizontalAlign = Middle;
		flow.layout = Vertical;

		var bg = new h2d.Bitmap(h2d.Tile.fromColor(0x403b6d, 1, 1), flow);
		flow.getProperties(bg).isAbsolute = true;

		for (a in actions) {
			var btn = new Button(a.str, function() {
				if (a.onClick != null) {
					a.onClick(this);
					if (linkedEntity.is(en.Employee))
						linkedEntity.as(en.Employee).backToNormalLook();
				}
			}, Const.BUTTON_WIDTH >> 1, Const.BUTTON_HEIGHT >> 1);
			if (!a.isEnable) btn.updateBGColor(0xe35959);
			flow.addChild(btn);
		}

		flow.reflow();

		bg.scaleX = wid = flow.outerWidth;
		bg.scaleY = hei = flow.outerHeight;

		// this.setPosition(linkedEntity.headX - (wid >> 1), linkedEntity.headY - hei);
		this.setPosition((linkedEntity.cx + 0.5) * Const.GRID - (wid >> 1), (linkedEntity.cy + 0.5 - 1) * Const.GRID - hei);

		level.tw.createS(this.alpha, 0 > 1, 0.2);
		this.y += 5;
		level.tw.createS(this.y, this.y - 5 , 0.2);
	}

	public function hide() {
		level.tw.createS(this.alpha, 0, 0.2);
		level.tw.createS(this.y, this.y - 5 , 0.2).onEnd = function() {
			remove();
			level.arActionPopups.remove(this);
		}
	}

	public function startNewTurn() {
		// if (!level.entitiesAreNearEachOther(level.player, linkedEntity))
			hide();
	}

}