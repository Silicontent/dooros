## Autoloaded script that holds and runs all critical system functions,
## including users, global settings, and system information.
class_name SystemClass
extends Node

## The current internal version of DoorOS. This value is updated whenever
## a new DoorOS patch is pushed.
const OS_VER: String = "0.3.1"

## Path to the boot file used to hold global system information.
## See [member load_boot_file].
const BOOT_PATH := "user://boot"

## Controls all logic related to creating, loading, and managing user
## information. The users directory is used to save user information on
## the disk.
@onready var _sys_user: UserManager = $UserManager

## The name of the system. Used by other computers when connecting over
## network and used in the terminal to identify this computer.
var hostname: String = "computer"


# BOOTING =====================================================================
func _ready() -> void:
	boot()


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


## Updates or creates the boot file with critical system information.
func write_boot_file() -> void:
	var f := FileAccess.open(BOOT_PATH, FileAccess.WRITE)
	f.store_var(hostname)
	f.close()


## Loads the main boot file that contains current DoorOS version information
## and other essential global system values. If the file cannot be found,
## it is automatically created with default values. Once the boot file is
## loaded, booting is allowed to begin.
func boot() -> void:
	# create the boot file if it doesn't exist
	if not FileAccess.file_exists(BOOT_PATH):
		write_boot_file()
	else:
		var f := FileAccess.open(BOOT_PATH, FileAccess.READ)
		# get the name of the system, if it is stored
		hostname = f.get_var()
		f.close()


# OPERATIONS ==================================================================
## Ensures critical system files are updated and stored to
## disk before termination.
func quit() -> void:
	write_boot_file()
	# quit OS
	get_tree().quit()


## Used to handle the quit request.
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		quit()


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
