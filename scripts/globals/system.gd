## Autoloaded script that holds and runs all critical system functions,
## including users, global settings, and system information.
class_name SystemClass
extends Node

## Path to the boot file used to hold global system information.
## See [member load_boot_file].
const BOOT_PATH := "user://boot"

## The current internal version of DoorOS. This value is updated whenever
## a new DoorOS patch is pushed.
const OS_VER := "0.0.2.2"

## Controls all logic related to creating, loading, and managing user
## information. The users directory is used to save user information on
## the disk.
@onready var _sys_user: UserManager = $UserManager


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


## Loads the main boot file that contains current DoorOS version information
## and other essential global system values. If the file cannot be found,
## it is automatically created with default values. Once the boot file is
## loaded, booting is allowed to begin.
func boot() -> bool:
	# flags if the BIOS animation can be skipped
	var skip_bios := false
	
	# create the boot file if it doesn't exist
	if not FileAccess.file_exists(BOOT_PATH):
		var f := FileAccess.open(BOOT_PATH, FileAccess.WRITE)
		f.store_var(OS_VER)
		f.close()
	else:
		var f := FileAccess.open(BOOT_PATH, FileAccess.READ)
		# check if the last boot was in this version
		if OS_VER == f.get_var():
			skip_bios = true
		f.close()
	
	return skip_bios


## Ensures critical system files are updated and stored to
## disk before termination.
func quit() -> void:
	# update the boot file with the current OS version
	var f := FileAccess.open(BOOT_PATH, FileAccess.WRITE)
	f.store_var(OS_VER)
	f.close()
	
	# quit OS
	get_tree().quit()


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


## Used to handle the quit request.
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		quit()
