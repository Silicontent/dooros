extends Control

@onready var anim := $AnimationPlayer
@onready var hint_lbl := $UserContainer/HintLabel

# SHA256 of the administrator password (hint: classic version password)
var password := "0bf52e390157da19c0c76f99c7c83179ba51e8c3e45b15a6387efb5ac0106a14"
var password_hint := "classic version's password"


func _ready() -> void:
	# set password hint
	hint_lbl.text = "Hint: " + password_hint


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_start") and not UserDebug.active:
		UserDebug.active = true
		var w := preload("res://scenes/dev/user_debug.tscn").instantiate()
		add_child(w)


func _on_password_submitted(new_text: String) -> void:
	# check given password hash against stored hash
	if new_text.sha256_text() == password:
		anim.play("login_success")
	else:
		anim.play("login_failure")


func _on_anim_finished(anim_name: StringName) -> void:
	if anim_name == "login_success":
		get_tree().change_scene_to_file("res://scenes/demo_end.tscn")
