extends HBoxContainer

# sent to tell the system to go to the desktop
signal to_desktop

# the password field
@onready var textbox := $PasswordEnter
# the button that can be used to initiate a log-in
@onready var login_btn := $LoginButton
# the loading spinner upon successful login
@onready var loading_icon := $LoadingIcon

# TODO: find out if this is the best way to animate a Control node in a container
var _initial_pos: Vector2
var _textbox_pos: Vector2


func _ready() -> void:
	# set up loading spinner
	loading_icon.hide()
	loading_icon.modulate = Color(1.0, 1.0, 1.0, 0.0)


# common set-up steps when animating
func start_anim() -> void:
	# disable password reentry during the animation
	textbox.editable = false
	login_btn.disabled = true
	
	# initialize needed positions if they aren't already
	if not _initial_pos:
		_initial_pos = position
	if not _textbox_pos:
		_textbox_pos = textbox.position


func animate_login_success() -> void:
	start_anim()
	
	var text_anim := create_tween()
	# animate the password box & button disappearing
	text_anim.set_parallel()
	text_anim.tween_property(self, "position", _initial_pos + Vector2(0, 20), 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	text_anim.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await text_anim.finished
	
	# reset container position to show loading spinner
	textbox.hide()
	login_btn.hide()
	set_position(_initial_pos)
	modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	# show the loading spinner
	loading_icon.show()
	var load_anim := create_tween()
	load_anim.tween_property(loading_icon, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.5).set_ease(Tween.EASE_IN_OUT)
	await load_anim.finished
	
	to_desktop.emit()


func animate_login_failure() -> void:
	start_anim()
	textbox.text = ""
	
	# set up animation
	var anim := create_tween()
	anim.set_loops(5)
	# animate textbox shake animation
	anim.tween_property(textbox, "position", _textbox_pos + Vector2(-20, 0), 0.04)
	anim.tween_property(textbox, "position", _textbox_pos + Vector2(20, 0), 0.04)
	await anim.finished
	textbox.set_position(_textbox_pos)
	
	# re-enable password entering
	textbox.editable = true
	login_btn.disabled = false
