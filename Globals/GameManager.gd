extends Node2D


func _ready() -> void:

	# Hide mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(_delta: float) -> void:

	# Close game on escape
	if (Input.is_action_just_pressed(InputMapActions.CLOSE_GAME)):
		get_tree().quit()
	
	# Toggle fullscreen
	if (Input.is_action_just_pressed(InputMapActions.TOGGLE_FULLSCREEN)):
		if (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	# Restart current level
	if (Input.is_action_just_pressed(InputMapActions.RESTART_LEVEL)):
		get_tree().reload_current_scene()