class_name LevelUI
extends CanvasLayer

@export var level: Level

@export_group("Nodes")
@export var black_ui: ColorRect

@export var light_shot_icon_scene: PackedScene
@export var light_shots_ui: Control
@export var light_shots_hbox: HBoxContainer

var light_shot_icons: Array[LightShotIcon]
var light_shot_icons_left := 0

@export var level_title_ui: Control
@export var level_title_label: Label

@export var level_info_ui: Control
@export var level_info_label: Label
var info_closed := false


func _ready() -> void:
	# Create initial light shot icons
	for i in level.light_shots:
		# Instantiate light shot icon
		var light_shot_icon: LightShotIcon = light_shot_icon_scene.instantiate()

		light_shots_hbox.add_child(light_shot_icon)
		light_shot_icons.append(light_shot_icon)

		light_shot_icons_left += 1

	# Set level title
	level_title_label.text = level.level_title

	# Animate fade out black
	var tween_black = get_tree().current_scene.create_tween()

	tween_black.tween_property(black_ui, "modulate", Color(1, 1, 1, 1), 0)
	tween_black.tween_property(black_ui, "modulate", Color(1, 1, 1, 0), .5)

	# Animate UI into view
	var tween_ui = get_tree().current_scene.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel()

	tween_ui.tween_property(light_shots_ui, "position", Vector2(light_shots_ui.position.x, 0), .5)
	tween_ui.tween_property(level_title_ui, "position", Vector2(level_title_ui.position.x, 0), .5)

	# Level info UI
	level_info_ui.modulate.a = 0

	if !level.level_info.is_empty():
		# Set level info
		level_info_label.text = level.level_info

		# Call deferred coz Godot UI be like
		call_deferred("animate_info_ui_in")
	else:
		info_closed = true


func _physics_process(_delta: float) -> void:
	# Close info box
	if Input.is_action_just_pressed(InputMapActions.CLOSE_INFO) && !info_closed:
		animate_info_ui_out()


func use_light_shot():
	if light_shot_icons_left <= 0: return

	# Pop last light shot icon in list
	var light_shot_icon = light_shot_icons.pop_back()

	# Use light shot icon
	light_shot_icon.use()


func fade_to_black():
	# Animate fade in black
	var tween_black = get_tree().current_scene.create_tween()

	tween_black.tween_property(black_ui, "modulate", Color(1, 1, 1, 1), .5)
	tween_black.tween_callback(faded_to_black)

	# Animate UI out of view
	var tween_ui = get_tree().current_scene.create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK).set_parallel()

	tween_ui.tween_property(light_shots_ui, "position", Vector2(light_shots_ui.position.x, -32), .5)
	tween_ui.tween_property(level_title_ui, "position", Vector2(level_title_ui.position.x, -32), .5)

	if !info_closed:
		animate_info_ui_out()


func faded_to_black():
	# Notify level that UI has faded to black
	level.level_faded_to_black()


func animate_info_ui_in() -> void:
	# Animate info UI into view
	level_info_ui.position.y += 32

	var tween_info_ui = get_tree().current_scene.create_tween().set_parallel()

	tween_info_ui.tween_property(level_info_ui, "position", Vector2(level_info_ui.position.x, level_info_ui.position.y - 32), .5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween_info_ui.tween_property(level_info_ui, "modulate:a", 1, .5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)


func animate_info_ui_out() -> void:
	# Animate info UI out of view
	info_closed = true

	# Animate info UI out of view
	var tween_info_ui = get_tree().current_scene.create_tween().set_parallel()

	tween_info_ui.tween_property(level_info_ui, "position", Vector2(level_info_ui.position.x, level_info_ui.position.y + 32), .5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween_info_ui.tween_property(level_info_ui, "modulate:a", 0, .5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)