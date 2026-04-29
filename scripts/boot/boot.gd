## A simple scene that gives the system time to boot and determine
## which scene to start with: startup or the BIOS.
extends Control


func _ready() -> void:
	if System.boot():
		# allow BIOS animation to be skipped if it has been
		# viewed once on this version
		get_tree().call_deferred("change_scene_to_file", "res://scenes/boot/startup.tscn")
	else:
		# otherwise, show the animation (can still skip with debug hotkey)
		get_tree().call_deferred("change_scene_to_file", "res://scenes/boot/bios.tscn")
