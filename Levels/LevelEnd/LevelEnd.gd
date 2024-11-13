class_name LevelEnd
extends Area2D

@export var level: Level


func _on_body_entered(_body: Node2D) -> void:
	# Notify level that end has been reached
	level.level_end_reached()
