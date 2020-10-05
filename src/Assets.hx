import dn.heaps.slib.*;

class Assets {
	public static var fontPixel : h2d.Font;
	public static var fontExpress9 : h2d.Font;
	public static var fontExpress18 : h2d.Font;
	public static var tiles : SpriteLib;

	static var STEP_SFXS : Array<dn.heaps.Sfx> = [];
	static var NEWREQUEST_SFXS : Array<dn.heaps.Sfx> = [];

	static var MUSIC : dn.heaps.Sfx;

	static var initDone = false;
	public static function init() {
		if( initDone )
			return;
		initDone = true;

		fontPixel = hxd.Res.fonts.minecraftiaOutline.toFont();
		fontExpress9 = hxd.Res.fonts.chevyray_express_regular_9.toFont();
		fontExpress18 = hxd.Res.fonts.chevyray_express_regular_18.toFont();
		tiles = dn.heaps.assets.Atlas.load("atlas/tiles.atlas");

		for (vg in VolumeGroup.createAll()) {
			// if (vg != VolumeGroup.Music)
				dn.heaps.Sfx.setGroupVolume(vg.getIndex(), dn.Lib.getEnumMetaFloat(vg, "volume") /* * OPTIONS_DATA.SFX_VOLUME */);
		}

		STEP_SFXS = [
			new dn.heaps.Sfx(hxd.Res.sfx.step1),
			new dn.heaps.Sfx(hxd.Res.sfx.step2),
			new dn.heaps.Sfx(hxd.Res.sfx.step3),
			new dn.heaps.Sfx(hxd.Res.sfx.step4),
		];

		NEWREQUEST_SFXS = [
			new dn.heaps.Sfx(hxd.Res.sfx.newRequest1),
			new dn.heaps.Sfx(hxd.Res.sfx.newRequest2),
			new dn.heaps.Sfx(hxd.Res.sfx.newRequest3),
			new dn.heaps.Sfx(hxd.Res.sfx.newRequest4),
		];
	}

	public static function GET_ICON_FOR_REQUEST(rt:RequestType):String {
		return switch (rt) {
			case NeedCoffee: "iconCoffee";
			case NeedFiles: "iconNeedFiles";
			case NeedPhotocopies: "iconCopyFiles";
			case PutFilesAway: "iconPutFilesAway";
		}
	}

	public static function PLAY_STEP_SFX() {
		STEP_SFXS[Std.random(STEP_SFXS.length)].playOnGroup(VolumeGroup.Step.getIndex());
	} 

	public static function PLAY_NEWREQUEST_SFX() {
		NEWREQUEST_SFXS[Std.random(NEWREQUEST_SFXS.length)].playOnGroup(VolumeGroup.Step.getIndex());
	} 

	public static function playMainMusic(fadeDuration:Float = 1) {
		if (MUSIC == null) {
			MUSIC = new dn.heaps.Sfx(#if hl hxd.Res.sfx.music #else hxd.Res.sfx.musicmp3 #end).playOnGroup(VolumeGroup.Music.getIndex(), true);
			MUSIC.volume = 0;
		}

		if (fadeDuration > 0)
			Main.ME.tw.createS(MUSIC.volume, 1, fadeDuration);
		else 
			MUSIC.volume = 1;
	}

	public static function changeMainMusicVolume(volume:Float, fadeDuration:Float = 1) {
		if (MUSIC == null)
			return;

		if (fadeDuration > 0)
			Main.ME.tw.createS(MUSIC.volume, volume, fadeDuration);
		else 
			MUSIC.volume = 0;
	}

	public static function stopMainMusic(fadeDuration:Float = 1) {
		if (MUSIC == null)
			return;

		if (fadeDuration > 0)
			Main.ME.tw.createS(MUSIC.volume, 0, fadeDuration);
		else 
			MUSIC.volume = 0;
	}
}