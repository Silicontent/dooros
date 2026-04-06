extends Control

# display the current progress to loading DoorOS
@onready var load_prog := $LoadProgress
# player for all the fancy startup animations
@onready var anim := $AnimationPlayer


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	# play the startup animation
	anim.play("startup")


func load_os() -> int:
	var err := System.load_system_info()
	
	# return the error code
	return err


func _on_anim_finished(anim_name: StringName) -> void:
	if anim_name == "startup":
		# attempt to load DoorOS
		var res := load_os()
		if res == 0:
			# success, show complete animation
			anim.play("load_complete")
		else:
			# failure, show error message
			printerr("DoorOS failed to load with error code ", res)
	
	elif anim_name == "load_complete":
		get_tree().change_scene_to_file("res://scenes/login.tscn")
	
	else:
		printerr("Startup animation failure. Finished animation has no result.")
