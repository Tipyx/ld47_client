typedef NotepadData = {
    var tu : Int;
    var actionType : ActionType;
    var peopleID : Int;
}

typedef PendingRequest = {
	var elapsedTU : Int;
	var type : ActionType;
}

enum ActionType {
    NeedCoffee;
    Copy;
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