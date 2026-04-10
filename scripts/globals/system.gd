extends Node

## The current internal version of DoorOS. This value is updated whenever
## a new DoorOS patch is pushed.
const OS_VER := "0.0.2.1"

## Controls all logic related to creating, loading, and managing user
## information. The users directory is used to save user information on
## the disk.
@onready var _sys_user := $UserManager


## Initializes all DoorOS system functionality, including system settings
## and user information. If anything goes wrong during initialization, an
## error code is returned. The following error codes can be returned:
## [br]0: initialization success
## [br]1: failed to load user data
func load_system_info() -> int:
	var res := 0
	
	if get_user_manager().get_users() == null:
		res = 1
	
	return res


# HELPERS =====================================================================
func get_user_manager() -> UserManager:
	return _sys_user


# UTILITIES ===================================================================
## Recursively removes a directory and all of its contents.
## [br] [br]
## Removes a directory and everything inside of it, allowing for the deletion
## of non-empty directories that Godot does not provide.
## [br] [br]
## Courtesy of
## [url=https://github.com/godotengine/godot-proposals/issues/11598#issuecomment-2599415910]sockeye-d[/url]
## on GitHub.
func remove_dir_recursive(directory: String) -> Error:
	for dir_name in DirAccess.get_directories_at(directory):
		remove_dir_recursive(directory.path_join(dir_name))
	for file_name in DirAccess.get_files_at(directory):
		DirAccess.remove_absolute(directory.path_join(file_name))
	
	return DirAccess.remove_absolute(directory)
