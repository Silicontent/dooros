extends Window

@onready var aud := $Audio
@onready var btn := $Control/ColorRect/Button
@onready var omen := $Control/Label
var appeared := false
var playing := false


func _ready() -> void:
	hide()
	omen.modulate = Color(1.0, 1.0, 1.0, 0.0)


func _process(_delta: float) -> void:
	if Input.is_action_just_released("debug_start") and not appeared:
		appeared = true
		show()


func _on_button_pressed() -> void:
	btn.disabled = true
	playing = true
	aud.play()
	$Timer.start()
	$Timer2.start()
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED


func _on_timer_timeout() -> void:
	var a := create_tween()
	a.tween_property(omen, "modulate", Color(1.0, 1.0, 1.0, 1.0), 10.0)


func _on_timer_2_timeout() -> void:
	System.quit()
