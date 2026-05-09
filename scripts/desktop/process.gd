class_name Process
extends Window
## An individual process running on the system.
##
## A process running on the system, with a unique ID and ability to
## run, start children, read and write, and close.

## The regular human-readable name of the process.
@export var process_name: String

## The unique ID used by the system to identify the process.
var pid: int


func _ready() -> void:
	# generate random PID
	# TODO: check that the PID is unique
	pid = randi()


func _on_close_requested() -> void:
	print_rich("[color=#FFFA0A]NOTICE: Closing process [/color][color=white]%d[/color] (%s)" % [pid, process_name])
	queue_free()
