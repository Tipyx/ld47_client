typedef NotepadData = {
    var tu : Int;
    var actionType : RequestType;
    var peopleID : Int;
}

typedef PendingRequest = {
	var elapsedTU : Int;
	var type : RequestType;
}

/* enum NPActionType {
    Coffee;
    Photocopie;
} */

enum RequestType {
	NeedCoffee;
	NeedFiles;
	NeedPhotocopies;
	PutFilesAway;
}

enum ObjectType {
	Coffee;
	Files;
	Photocopy;
}

typedef PlayerData = {
	var maximumNotepadEntry : Int;
	var maximumInventoryStorage : Int;
	var planningDatas : Map<String, Array<NotepadData>>;
	var xp : Int;
	var nextCostInventory : Int;
	var nextCostNotepad : Int;
}

typedef Object = {
	var type : ObjectType;
	var linkedEmployee : Null<en.Employee>;
}

enum VolumeGroup {
	@volume(0.5) CoffeeGrinder;
	@volume(1) Step;
	@volume(1) NewRequest;
	@volume(1) Photocopy;
	@volume(1) Splash;
	@volume(1) Cupboard;
	@volume(1) Victory;
// 	@volume(0.45) ClickTile;
// 	@volume(0.75) ClickButton;
// 	@volume(0.75) WrongTile;
// 	@volume(0.75) Whoosh;
// 	@volume(1) FieldAppear;
	@volume(1) Music;
// 	@volume(0.75) Defeat;
}