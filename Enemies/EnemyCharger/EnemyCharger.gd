class_name Charger
extends StaticBody2D

@export var line: Line2D

var deactivated := false


func deactivate():
	deactivated = true
