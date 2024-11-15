extends Node2D

var current_level = 0
var levels: Array[PackedScene] = [
	preload("res://Levels/Level2.tscn"),
	preload("res://Levels/Level3.tscn"),
	preload("res://Levels/Level1.tscn")
]


func _ready() -> void:
	# Hide mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	# Game manager always runs
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS


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


func go_to_next_level():
	# Do not attempt to load next level if maxed out
	if (current_level >= levels.size() - 1):
		get_tree().reload_current_scene()
		return

	# Increment current level
	current_level += 1

	# Change scene to next level
	get_tree().change_scene_to_packed(levels[current_level])


func go_to_previous_level():
	# Do not attempt to load previous level if at start
	if (current_level <= 0):
		get_tree().reload_current_scene()
		return

	# Decrease current level
	current_level -= 1

	# Change scene to previous level
	get_tree().change_scene_to_packed(levels[current_level])


func restart_game():
	# Reset current level
	current_level = 0

	# Go to start of game
	get_tree().change_scene_to_packed(levels[current_level])
