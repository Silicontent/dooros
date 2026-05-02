extends TextureRect

signal to_desktop


func _ready() -> void:
	modulate = Color(1.0, 1.0, 1.0, 0.0)


func _on_load() -> void:
	var load_anim := create_tween()
	# animate the loading spinner appearing
	load_anim.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.5).set_ease(Tween.EASE_IN_OUT)
	await load_anim.finished
	
	# tell the system to go to the desktop
	to_desktop.emit()
