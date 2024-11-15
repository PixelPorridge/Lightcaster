class_name Enemy
extends CharacterBody2D

@export var deactivatable := true
@export var level: Level

var deactivated := false


func try_deactivate():
	if deactivatable:
		deactivated = true


func force_deactivate():
	deactivated = true


func catch_player():
	level.catch_player(self)
