extends Node

var current_level = 0
var levels: Array[PackedScene] = [
	preload("res://Levels/Level1.tscn"),
	preload("res://Levels/Level2.tscn"),
	preload("res://Levels/Level3.tscn"),
	preload("res://Levels/Level4.tscn"),
	preload("res://Levels/Level5.tscn"),
	preload("res://Levels/Level6.tscn"),
	preload("res://Levels/Level7.tscn"),
	preload("res://Levels/Level8.tscn"),
	preload("res://Levels/Level9.tscn"),
	preload("res://Levels/Level10.tscn"),
	preload("res://Levels/GameFinish.tscn")
]


func _ready() -> void:
	# Hide mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	# Game manager always runs
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS


func _process(_delta: float) -> void:
	pass
	# Close game on escape
	#if (Input.is_action_just_pressed(InputMapActions.CLOSE_GAME)):
	#	get_tree().quit()

	# Toggle fullscreen
	#if (Input.is_action_just_pressed(InputMapActions.TOGGLE_FULLSCREEN)):
	#	if (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN):
	#		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	#	else:
	#		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


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


func play_audio_stream(audio_stream: AudioStream, at_position: Vector2, volume: float = 0):
	# Create new audio steam player
	var audio_stream_player = AudioStreamPlayer2D.new()

	audio_stream_player.stream = audio_stream
	audio_stream_player.position = at_position
	audio_stream_player.volume_db = volume

	# Queue free after audio is finished
	audio_stream_player.finished.connect(func(): audio_stream_player.queue_free())

	get_tree().current_scene.add_child(audio_stream_player)

	audio_stream_player.play()
