class_name Level
extends Node2D

@export var level_title: String
@export_range(0, 100) var light_shots: int

@export var level_ui: LevelUI

@export var player: Player
@export var camera: Camera2D

@export var alarm_light: DirectionalLight2D


func use_light_shot():
	if light_shots <= 0: return

	light_shots -= 1
	level_ui.use_light_shot()


func level_end_reached():
	# Begin fading to black
	level_ui.fade_to_black()


func level_faded_to_black():
	# Notify game manager to go to next level
	GameManager.go_to_next_level()


func restart_level():
	get_tree().reload_current_scene()


func catch_player(enemy: Enemy):
	# Camera position is between player and enemy
	var camera_position = player.global_position.lerp(enemy.global_position, 0.5)

	var tween = get_tree().current_scene.create_tween()

	# Zoom camera to position between player and enemy
	tween.tween_property(camera, "position", camera_position, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.parallel().tween_property(camera, "zoom", Vector2(2, 2), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)

	tween.tween_interval(1)

	# Fade to black then restart level
	tween.chain().tween_property(level_ui.black_ui, "modulate", Color(1, 1, 1, 1), .5).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(restart_level)

	# Alarm light
	var tween_alarm_light = get_tree().current_scene.create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).set_loops(4)

	tween_alarm_light.tween_property(alarm_light, "energy", 1, .4)
	tween_alarm_light.tween_property(alarm_light, "energy", .3, .4)
