class_name LevelUI
extends CanvasLayer

@export var level: Level
@export var black_animation_tree: AnimationTree


func fade_to_black():
	# Begin fade to black animation
	black_animation_tree["parameters/conditions/level_finished"] = true
	

func faded_to_black():
	# Notify level that UI has faded to black
	level.level_faded_to_black()