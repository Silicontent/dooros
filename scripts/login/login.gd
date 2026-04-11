extends Control

# plays login animations upon login success or failure
@onready var anim := $AnimationPlayer

# the currently selected user to log in
var selected_user: User


func _ready() -> void:
	pass


# USER INFORMATION ============================================================
func load_user_information(u: User) -> void:
	# set selected user
	selected_user = u
	
	# load display name
	%DisplayName.text = u.display_name
	# load password hint
	if u.hint != "":
		%HintLabel.text = "Hint: " + u.hint
	# TODO: load a user image/icon


# PASSWORD CHECKING ===========================================================
func _on_password_submitted(new_text: String) -> void:
	# check given password hash against stored hash
	if new_text.sha256_text() == selected_user.password:
		anim.play("login_success")
	else:
		anim.play("login_failure")


func _on_anim_finished(anim_name: StringName) -> void:
	if anim_name == "login_success":
		# log the user into the desktop
		get_tree().change_scene_to_file("res://scenes/desktop/desktop.tscn")


# DEBUG =======================================================================
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_start") and not UserDebug.active:
		UserDebug.active = true
		var w := preload("res://scenes/dev/user_debug.tscn").instantiate()
		add_child(w)
