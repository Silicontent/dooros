extends LineEdit

# the loading spinner that appears upon successful login
@onready var load_icon := $Loading

# TODO: find out if this is the best way to animate a Control node in a container
var _initial_pos: Vector2


func _ready() -> void:
	# hide the loading spinner
	load_icon.modulate = Color(1.0, 1.0, 1.0, 0.0)


# common set-up steps when animating
func start_anim() -> void:
	# disable editing of the password field
	editable = false
	if not _initial_pos:
		_initial_pos = position


func animate_login_success() -> void:
	start_anim()
	
	var text_anim := create_tween()
	# animate the password box disappearing
	text_anim.set_parallel()
	text_anim.tween_property(self, "position", _initial_pos + Vector2(0, 20), 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	text_anim.tween_property(self, "self_modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await text_anim.finished
	
	var load_anim := create_tween()
	# animate the loading spinner appearing
	# INFO: the spinner also follows the textbox's position
	load_anim.tween_property(load_icon, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.5).set_ease(Tween.EASE_IN_OUT)
	await load_anim.finished
	
	# hide the textbox
	hide()


func animate_login_failure() -> void:
	start_anim()
	text = ""
	
	# set up animation
	var anim := create_tween()
	anim.set_loops(5)
	# animate textbox shake animation
	anim.tween_property(self, "position", _initial_pos + Vector2(-20, 0), 0.04)
	anim.tween_property(self, "position", _initial_pos + Vector2(20, 0), 0.04)
	await anim.finished
	set_position(_initial_pos)
	
	# re-enable password entering
	editable = true
