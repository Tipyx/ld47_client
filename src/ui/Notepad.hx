package ui;

class Notepad extends dn.Process {
    public static var ME : Notepad;
    
    public var game(get,never) : Game; inline function get_game() return Game.ME;
	public var fx(get,never) : Fx; inline function get_fx() return Game.ME.fx;
	public var level(get,never) : Level; inline function get_level() return Game.ME.level;

	var flow : h2d.Flow;

	public function new() {
        super(Main.ME);
        
        ME = this;

		createRootInLayers(Main.ME.root, Const.DP_UI);

		flow = new h2d.Flow(root);
    }
}