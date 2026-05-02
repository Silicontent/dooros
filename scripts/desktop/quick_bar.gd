extends TextureRect

@onready var clock := $BarContainer/BarContentsContainer/RightBar/BarClock


func _process(_delta: float) -> void:
	if %SecretIDK.playing:
		clock.text = "2:41 AM\n9/17/2006"
	else:
		update_clock()


# ACTIONS =====================================================================
func _on_system_menu_pressed() -> void:
	if not %SecretIDK.playing:
		System.quit()


# ONGOING PROCESSES ===========================================================
func update_clock() -> void:
	# get system time
	var t := Time.get_datetime_dict_from_system()
	# determine AM or PM
	# TODO: options to allow 24-hour clock support
	var period := "AM" if t.hour < 12 else "PM"
	# add zero-padding to minutes
	var minute: String = str(t.minute)
	minute = minute if len(minute) > 1 else "0" + minute
	
	# display information
	clock.text = "%s:%s %s\n%s/%s/%s" % [(t.hour % 12), minute, period, t.month, t.day, t.year]
