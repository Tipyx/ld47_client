typedef NotepadData = {
    var tu : Int;
    var actionType : NPActionType;
    var peopleID : Int;
}

typedef PendingRequest = {
	var elapsedTU : Int;
	var type : RequestType;
}

enum NPActionType {
    Coffee;
    File;
}

enum RequestType {
	NeedCoffee;
}

enum ObjectType {
	Coffee;
	Files;
}

typedef PlayerData = {
	var maximumNotepadEntry : Int;
	var maximumInventoryStorage : Int;
	var planningDatas : Map<String, Array<NotepadData>>;
}