class_name UserDebug
extends Window

static var active := false

var u: User = null


func _ready() -> void:
	title = "DoorOS %s - User Debug Menu" % [System.OS_VER]


func _on_create_button_pressed() -> void:
	var res := System.get_user_manager().create_user(%Username.text, %DisplayName.text, %Admin.button_pressed, %Password.text)
	%ResultDisplay.text = "User creation request: %d" % [res]
	if res == 0:
		%Username.text = ""
		%DisplayName.text = ""
		%Admin.button_pressed = false
		%Password.text = ""


func _on_username_2_text_submitted(new_text: String) -> void:
	u = System.get_user_manager().load_user(new_text)
	%ResultDisplay.text = "User fetch request: %s" % [u]
	if u:
		%InfoDisplay.text = "Username: %s\nDisplay Name: %s\nAdmin?  %s" % [u.username, u.display_name, u.admin]
	else:
		%InfoDisplay.text = "Username: {}\nDisplay Name: {}\nAdmin?  {}"


func _on_password_2_text_submitted(new_text: String) -> void:
	if u:
		%InfoDisplay2.text = "Fetched hash match?  %s" % [u.password == new_text.sha256_text()]
		%ResultDisplay.text = "Password check request: 0"
	else:
		%ResultDisplay.text = "Password check request: fetch a user first"


func _on_close_requested() -> void:
	active = false
	queue_free()


func _on_delete_button_pressed() -> void:
	if u:
		var res := System.get_user_manager().delete_user(u.username)
		%ResultDisplay.text = "User deletion request: %d" % [res]
	else:
		%ResultDisplay.text = "User deletion request: fetch a user first"
