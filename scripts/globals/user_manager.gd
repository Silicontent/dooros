extends Node

# location where user profiles are stored
const USERS_DIR := "user://users"
# user data file type
const USER_TYPE := ".user"


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
		create_user("admin", true, "Administrator")
	
	# load all users
	for path in DirAccess.get_files_at(USERS_DIR):
		var u := load_user(path.trim_suffix(USER_TYPE))
		users.append(u)
	
	return users


## Creates a new user and adds it to the system.
## [br] [br]
## Various error codes are returned depending on the result of user creation.
## [br]0: User creation successful.
## [br]-1: User already exists.
## [br]1+: Other error codes are from [enum Error]
func create_user(username: String = "user", admin: bool = false, display_name: String = "User") -> int:
	# the resulting error code
	var res := 0
	# path to the user's file
	var user_path := USERS_DIR + "/" + username + USER_TYPE
	
	if (FileAccess.file_exists(user_path)):
		# user already exists, so cancel user creation
		res = -1
	else:
		# store the user information in a new file
		var user_file := FileAccess.open(user_path, FileAccess.WRITE)
		user_file.store_var(username)
		user_file.store_var(admin)
		user_file.store_var(display_name)
	
	return res


func load_user(username: String) -> User:
	var user: User = null
	var user_path := USERS_DIR + "/" + username + USER_TYPE
	
	if (FileAccess.file_exists(user_path)):
		var f := FileAccess.open(user_path, FileAccess.READ)
		
		# get user information from file to User resource
		user = User.new()
		user.username = f.get_var()
		user.admin = f.get_var()
		user.display_name = f.get_var()
	
	return user
