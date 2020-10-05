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