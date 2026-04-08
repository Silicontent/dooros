class_name UserManager
extends Node
## A system node responsible for user management. Any information about or
## actions on a user is handled by this node. The user currently logged-in is
## also stored here.

# location where user profiles are stored
const USERS_DIR := "user://users"
# various file names each user has
const INFO_FILE := "info"
const PW_FILE := "pw"

## The user currently logged into the system.
var _user: User = null


# CURRENT USER ================================================================
func get_current_user() -> User:
	return _user


func is_admin() -> bool:
	return _user.admin


func get_current_password() -> String:
	return _user.password


# MANAGEMENT FUNCTIONS ========================================================
## Get an array of User resources. This function goes through every user file
## in the users directory to fetch information for all users.
## [br] [br]
## If the users directory cannot be found or doesn't exist, it will be created
## with the default administrator user. Then, users will be loaded as normal.
func get_users() -> Array[User]:
	var users: Array[User]
	
	# check for a user directory
	if not DirAccess.dir_exists_absolute(USERS_DIR):
		# create the users directory
		DirAccess.make_dir_absolute(USERS_DIR)
		# create the default administrator user
		create_user("admin", "Administrator", true, "pbct")
	
	# load all users
	for path in DirAccess.get_directories_at(USERS_DIR):
		var u := load_user(path)
		users.append(u)
	
	return users


## Creates a new user and adds it to the system.
## [br] [br]
## [b]username[/b]: The internal unique username needed by the system.[br]
## [b]display_name[/b]: The human-readable name that can contain special characters.[br]
## [b]admin[/b]: A flag determining if the user has complete access to the system.[br]
## [b]password[/b]: The user's password as PLAINTEXT. It is hashed before being stored.
## [br] [br]
## Various error codes are returned depending on the result of user creation.
## [br]0: User creation successful.
## [br]-2: Username was not provided or was empty.
## [br]-1: User already exists.
## [br]1+: Other error codes are from [enum Error]
func create_user(username: String, display_name: String, admin: bool = false, password: String = "") -> int:
	# the resulting error code
	var res := 0
	# path to the user's personal directory (comparable to the Linux ~ folder)
	var user_path := USERS_DIR + "/" + username + "/"
	
	if username:
		# username must not be null or empty, so cancel user creation
		res = -2
	elif (DirAccess.dir_exists_absolute(user_path)):
		# user already exists, so cancel user creation
		res = -1
	else:
		# create the user's directory
		DirAccess.make_dir_absolute(user_path)
		
		# store basic user information in a new file
		var basic_info := FileAccess.open(user_path + INFO_FILE, FileAccess.WRITE)
		basic_info.store_var(username)
		basic_info.store_var(display_name)
		basic_info.store_var(admin)
		basic_info.close()
		
		# store password in its own file
		var pw_file := FileAccess.open(user_path + PW_FILE, FileAccess.WRITE)
		pw_file.store_var(password.sha256_text())
		pw_file.close()
	
	return res


## Loads a user off the disk.
## [br] [br]
## All information about the user is gotten off the disk and stored into a
## single User resource for access during runtime. Returns a [User]
## resource containing the user's information, or [code]null[/code] if the user
## does not exist.
func load_user(username: String) -> User:
	# holds the User resource containing all needed user information
	var u: User = null
	# path to the user's personal directory
	var user_path := USERS_DIR + "/" + username + "/"
	
	if (DirAccess.dir_exists_absolute(user_path) and username):
		u = User.new()
		
		# TODO: add checks for these files to ensure complete error handling
		var info := FileAccess.open(user_path + INFO_FILE, FileAccess.READ)
		u.username = info.get_var()
		u.display_name = info.get_var()
		u.admin = info.get_var()
		info.close()
		
		var pw := FileAccess.open(user_path + PW_FILE, FileAccess.READ)
		u.password = pw.get_var()
		pw.close()
	
	return u


## Permanently deletes a user from the hard disk.
## [br] [br]
## This function removes all information about the user. If the user does not
## exist, the function returns a 1; otherwise, [enum Error] is returned. If the user to
## be deleted is the current user, the current user is reset to [code]null[/code].
func delete_user(username: String) -> int:
	var res := 0
	
	# path to the user's personal directory
	var user_path := USERS_DIR + "/" + username + "/"
	
	if (DirAccess.dir_exists_absolute(user_path)):
		# resets the current user if it is being deleted
		if _user and _user.username == username:
			_user = null
		res = System.remove_dir_recursive(user_path)
	else:
		res = 1
	
	return res
