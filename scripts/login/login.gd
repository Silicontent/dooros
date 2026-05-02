extends Control

# the currently selected user to log in
@export var selected_user: User

# container for user buttons
@onready var user_list_display := $MarginContainer/HBoxContainer/UserListPanel/MarginContainer/ScrollContainer/UserListContainer
# list of User resources currently on disk
var user_list: Array[User]


func _ready() -> void:
	load_user_list()
	# load first user in the list
	# TODO: replace this with previously-logged-in user
	load_user_information(user_list[0])


# USER INFORMATION ============================================================
func load_user_information(u: User) -> void:
	# set selected user
	selected_user = u
	
	# load display name
	%DisplayName.text = u.display_name
	
	# disable the password textbox if there is no password
	%PasswordContainer.textbox.visible = u.password != System.get_user_manager().NO_PASS
	
	# load password hint
	%HintLabel.visible_ratio = 0.0
	if u.hint != "":
		%HintLabel.text = "Hint: " + u.hint
	# TODO: load a user image/icon


func load_user_list() -> void:
	var btn_theme := load("uid://b5wj2dagftl17")
	
	# create list of users in GUI
	user_list = System.get_user_manager().get_users()
	for i in range(len(user_list)):
		# create new button for a user
		var b := Button.new()
		b.text = user_list[i].display_name
		b.theme = btn_theme
		b.pressed.connect(load_user_information.bind(user_list[i]))
		user_list_display.add_child(b)


# PASSWORD CHECKING ===========================================================
func go_to_desktop() -> void:
	# TODO: properly set up desktop environment for the selected user
	get_tree().change_scene_to_file("res://scenes/desktop/desktop.tscn")


func check_password(given: String) -> void:
	# check given password hash against stored hash
	# or, if the user doesn't have a password, grant log-in
	if given.sha256_text() == selected_user.password or selected_user.password == System.get_user_manager().NO_PASS:
		%HintLabel.visible_ratio = 0.0
		%PasswordContainer.animate_login_success()
	else:
		if selected_user.hint != "":
			%HintLabel.visible_ratio = 1.0
		await %PasswordContainer.animate_login_failure()


func _on_password_submitted(new_text: String) -> void:
	check_password(new_text)

func _on_login_button_pressed() -> void:
	check_password(%PasswordContainer.textbox.text)


# DEBUG =======================================================================
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_start") and not UserDebug.active:
		UserDebug.active = true
		var w := preload("res://scenes/dev/user_debug.tscn").instantiate()
		w.root = self
		add_child(w)


func reset_list() -> void:
	# DEBUG: used by UserDebug menu
	user_list.clear()
	for u in user_list_display.get_children():
		u.queue_free()
	load_user_list()
