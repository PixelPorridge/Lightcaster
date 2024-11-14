class_name LightShotIcon
extends Control


@export var white_panel: Panel


func _ready() -> void:
	# Call deferred as setting pivot offset too early does not work correctly
	call_deferred("setup_pivot_offset")


func setup_pivot_offset():
	# Set the pivot offset so node scales from center
	white_panel.pivot_offset = white_panel.size / 2


func use():
	# Animate node scale then queue free
	var tween = get_tree().current_scene.create_tween()
	
	tween.tween_property(white_panel, "scale", Vector2.ZERO, .1)

	tween.tween_callback(white_panel.queue_free)
