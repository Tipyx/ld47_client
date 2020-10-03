typedef NotepadLign = {
    var tu : Int;
    var icone : ActionType;
    var peopleID : Int;
}

typedef PendingRequest = {
	var elapsedTU : Int;
	var type : ActionType;
}

enum ActionType {
    Coffee;
    Copy;
}