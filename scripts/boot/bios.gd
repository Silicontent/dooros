extends Control

var current_step := 0
var current_text: String

@onready var bios_display := $TerminalDisplay
@onready var anim := $AnimationPlayer


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	# play the bootup animation
	anim.play("bios_boot")


func _process(_delta: float) -> void:
	# allow the BIOS animation to be skipped
	if Input.is_action_just_pressed("debug_start"):
		get_tree().change_scene_to_file("res://scenes/boot/startup.tscn")


func _on_anim_finished(_anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://scenes/boot/startup.tscn")


# HELPERS =====================================================================
# These are a bunch of really ugly functions used to make the whole fake
# BIOS thing kinda look real. This is probably the worst code I've ever
# written in my life. Please don't look here. Thank you in advance.

func show_info() -> void:
	if OS.get_name() == "Web":
		bios_display.append_text("\n\nCPU..........................Intel Pentium III 32-bit\n"
		+ "Cores........................1 logical core\n"
		+ "Total Memory.................134217728 bytes\n"
		+ "Graphics Card................nVidia RIVA TNT2 Ultra\n"
		+ "Boot Mode....................BIOS\n\n"
		+ "Trying boot device #1........")
	else:
		bios_display.append_text("\n\nCPU.........................." + OS.get_processor_name() + "\n"
		+ "Cores........................" + str(OS.get_processor_count()) + " logical core(s)\n"
		+ "Total Memory................." + str(OS.get_memory_info()["physical"]) + " bytes\n"
		+ "Graphics Card................" + str(RenderingServer.get_video_adapter_name()) + "\n"
		+ "Boot Mode....................BIOS\n\n"
		+ "Trying boot device #1........")
	
	current_text = bios_display.get_parsed_text()


func show_spinner(state: String) -> void:
	bios_display.text = current_text + state
	if state == "Ready":
		bios_display.append_text("\n")
		current_text += state + "\n"


func update_current() -> void:
	var t := "Booting DoorOS " + System.OS_VER
	if len(t) >= 29:
		t += "..."
	else:
		while len(t) < 29:
			t += "."
	current_text += t
