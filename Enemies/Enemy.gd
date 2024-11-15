class_name Enemy
extends StaticBody2D

@export var deactivatable := true
@export var level: Level
@export var chargers: Array[Charger]

var deactivated := false


func try_deactivate():
	if deactivatable:
		# Do not deactivate if chargers are not deactivated
		for charger in chargers:
			if !charger.deactivated: return

		deactivated = true


func catch_player():
	level.catch_player(self)


func _physics_process(_delta: float) -> void:
	# Draw charging line for each charger
	for charger in chargers:
		charger.line.clear_points()

		charger.line.add_point(Vector2.ZERO)
		charger.line.add_point(global_position - charger.global_position)
