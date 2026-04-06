extends Node

## The current internal version of DoorOS. This value is updated whenever
## a new DoorOS patch is pushed.
const OS_VER := "0.0.1.dev"

## Controls all logic related to creating, loading, and managing user
## information. The users directory is used to save user information on
## the disk.
@onready var user_manager := $UserManager


## Initializes all DoorOS system functionality, including system settings
## and user information. If anything goes wrong during initialization, an
## error code is returned. The following error codes can be returned:
## [br]0: initialization success
## [br]1: failed to load user data
func load_system_info() -> int:
	var res := 0
	
	if user_manager.get_users() == null:
		res = 1
	
	return res


# DEBUG
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
