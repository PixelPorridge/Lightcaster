class_name PauseMenu
extends CanvasLayer

@export var black: ColorRect
@export var menu: Control


func _process(_delta: float) -> void:
	# Show or hide pause menu
	if Input.is_action_just_pressed(InputMapActions.PAUSE_GAME):
		if !get_tree().paused:
			show_pause_menu()
		else:
			hide_pause_menu()


func show_pause_menu():
	# Pause game
	get_tree().paused = true

	# Show mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	visible = true

	black.modulate = Color(1, 1, 1, 0)
	menu.modulate = Color(1, 1, 1, 0)
	menu.position.y = 8

	# Animate pause menu in
	var tween = get_tree().current_scene.create_tween().bind_node(self).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT).set_parallel()

	tween.tween_property(black, "modulate", Color(1, 1, 1, .5), .5)
	tween.tween_property(menu, "modulate", Color(1, 1, 1, 1), .5)
	tween.tween_property(menu, "position", Vector2(menu.position.x, 0), .5)


func hide_pause_menu():
	# Hide mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	# Animate pause menu out
	var tween = get_tree().current_scene.create_tween().bind_node(self).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT).set_parallel()

	tween.tween_property(black, "modulate", Color(1, 1, 1, 0), .5)
	tween.tween_property(menu, "modulate", Color(1, 1, 1, 0), .5)
	tween.tween_property(menu, "position", Vector2(menu.position.x, 8), .5)

	# Unpause game
	get_tree().paused = false


func _on_resume_pressed() -> void:
	# Resume game
	hide_pause_menu()


func _on_restart_level_pressed() -> void:
	# Unpause game
	get_tree().paused = false
	
	# Reload scene
	get_tree().reload_current_scene()


func _on_previous_level_pressed() -> void:
	# Unpause game
	get_tree().paused = false

	# Go to previous level
	GameManager.go_to_previous_level()


func _on_restart_game_pressed() -> void:
	# Unpause game
	get_tree().paused = false

	# Restart game
	GameManager.restart_game()
