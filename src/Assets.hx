import dn.heaps.slib.*;

class Assets {
	public static var fontPixel : h2d.Font;
	public static var fontExpress9 : h2d.Font;
	public static var fontExpress18 : h2d.Font;
	public static var tiles : SpriteLib;

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
	}

	public static function GET_ICON_FOR_REQUEST(rt:RequestType):String {
		return switch (rt) {
			case NeedCoffee: "iconCoffee";
			case NeedFiles: "iconNeedFiles";
			case NeedPhotocopies: "iconCopyFiles";
			case PutFilesAway: "iconPutFilesAway";
		}
	}
}