extends ColorRect

signal faded_in

# the file to load after the transition
@export_file("*.tscn") var next_scene_path: String
# speed multiplier of the fade animation
@export_range(-4.0, 4.0) var fade_speed := 1.0
# optional delays before fading in and after fading out
@export_range(0.0, 5.0) var start_delay := 0.0
@export_range(0.0, 5.0) var end_delay := 0.0

# the fade animation player
@onready var anim_player := $AnimationPlayer
# the timer that controls fade delays
@onready var delay_timer := $DelayTimer


func _ready() -> void:
	show()
	
	# set the playback speed
	anim_player.speed_scale = fade_speed
	# add the start delay
	if start_delay > 0.0:
		delay_timer.wait_time = start_delay
		delay_timer.start()
		await delay_timer.timeout
	
	# fade in
	anim_player.play_backwards("fade")
	await anim_player.animation_finished
	emit_signal("faded_in")


func transition_to(next_scene := next_scene_path) -> void:
	# fade out
	anim_player.play("fade")
	await anim_player.animation_finished
	
	# add the end delay
	if end_delay > 0.0:
		delay_timer.wait_time = end_delay
		delay_timer.start()
		await delay_timer.timeout
	
	# change the scene
	get_tree().change_scene_to_file(next_scene)
