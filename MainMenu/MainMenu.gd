class_name MainMenu
extends Control

@export var black: ColorRect
@export var play_button: Button


func _ready() -> void:
	# Show mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	black.modulate.a = 1

	# Fade out black
	var tween = get_tree().current_scene.create_tween()

	tween.tween_property(black, "modulate:a", 0, .5)


func _on_play_button_pressed() -> void:
	# Disable button
	play_button.disabled = true

	# Fade in black then start game
	var tween = get_tree().current_scene.create_tween()

	tween.tween_property(black, "modulate:a", 1, .5)

	# Start game
	tween.tween_callback(func():
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		GameManager.start_game()
	)
