extends Process

## 
@onready var text: TextEdit = $TextSection

@onready var result := $VBoxContainer/CommandResult

## The current working directory. All commands run will execute
## relative to this directory.
var working_dir := "~"


func _ready() -> void:
	super()
	working_dir = pwd()
	text.text = create_prefix()


func _process(_delta: float) -> void:
	pass


# WORKING DIRECTORY ===========================================================
func create_prefix() -> String:
	return "%s@%s:%s$ " % [System.get_user_manager().get_current_user().username, System.hostname, working_dir]


func pwd() -> String:
	return "~"


func _on_text_caret_changed() -> void:
	pass #print(text.get_caret_column())


# PARSING =====================================================================
func _on_command_submitted(raw: String) -> void:
	var cmd_list := raw.split(" ")
	var res := "error"
	
	if len(cmd_list) > 0:
		match cmd_list[0]:
			"ls":
				res = "list directory"
			"cd":
				res = "change directory"
			"exit":
				close_requested.emit()
			"clear":
				res = ""
				result.text = ""
			"pwd":
				res = pwd()
		
		result.text += res + "\n"
