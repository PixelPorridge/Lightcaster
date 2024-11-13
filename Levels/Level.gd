class_name Level
extends Node2D

@export var level_title: String
@export_range(0, 100) var light_shots: int

@export var level_ui: LevelUI


func level_end_reached():
    # Begin fading to black
    level_ui.fade_to_black()


func level_faded_to_black():
    # Notify game manager to go to next level
    GameManager.go_to_next_level()