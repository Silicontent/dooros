extends Control

# display the current progress to loading DoorOS
@onready var load_prog := $LoadProgress
# player for all the fancy startup animations
@onready var anim := $AnimationPlayer


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	# play the startup animation
	anim.play("startup")


func _on_anim_finished(anim_name: StringName) -> void:
	if anim_name == "startup":
		# attempt to load DoorOS
		var res := System.load_system_info()
		if res == 0:
			# success, show complete animation
			anim.play("load_complete")
		else:
			# failure, show error message
			var err := "DoorOS %s failed to load with error code %d" % [System.OS_VER, res]
			%ErrorDisplay.text = err
			push_error(err)
	
	elif anim_name == "load_complete":
		get_tree().change_scene_to_file("uid://b7t4t87nxscro")
	
	else:
		printerr("Startup animation failure. Finished animation has no result.")
