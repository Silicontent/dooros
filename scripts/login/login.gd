extends Control

# the currently selected user to log in
@export var selected_user: User


func _ready() -> void:
	load_user_list()
	# load first user in the list
	# TODO: replace this with previously-logged-in user
	load_user_information(System.get_user_manager().get_users()[0])


# USER INFORMATION ============================================================
func load_user_information(u: User) -> void:
	# set selected user
	selected_user = u
	
	# load display name and stored username
	%DisplayName.text = u.display_name
	%UsernameLabel.text = u.username
	# indicate administrator permissions
	if u.admin:
		%UsernameLabel.text += " (admin)"
	
	%PasswordContainer.textbox.clear()
	# disable the password textbox if there is no password
	%PasswordContainer.textbox.visible = u.password != System.get_user_manager().NO_PASS
	
	# load password hint
	%HintLabel.visible_ratio = 0.0
	if u.hint != "":
		%HintLabel.text = "Hint: " + u.hint
	# TODO: load a user image/icon


func load_user_list() -> void:
	var btn_theme := load("uid://bsu7t6bn4kb2o")
	var btn_group := load("uid://3xnadkvc5fvs")
	
	# create list of users in GUI
	for i in range(len(System.get_user_manager().get_users())):
		# create new button for a user
		var b := Button.new()
		b.text = System.get_user_manager().get_users()[i].display_name
		b.toggle_mode = true
		b.theme = btn_theme
		b.button_group = btn_group
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS_FORCE
		b.pressed.connect(load_user_information.bind(System.get_user_manager().get_users()[i]))
		# if this is the first user, set this button as pressed
		# TODO: update this so that the previously-logged-in user is pressed
		if i == 0: b.button_pressed = true
		
		%UserListContainer.add_child(b)


# PASSWORD CHECKING ===========================================================
func go_to_desktop() -> void:
	# TODO: properly set up desktop environment for the selected user
	System.get_user_manager().set_current_user(selected_user)
	get_tree().change_scene_to_file("uid://cd3ra65ga6v0p")


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
	System.get_user_manager().get_users(true)
	# DEBUG: used by UserDebug menu
	for u in %UserListContainer.get_children():
		u.queue_free()
	load_user_list()
	load_user_information(System.get_user_manager().get_users()[0])
