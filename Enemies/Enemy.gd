class_name Enemy
extends StaticBody2D

@export var deactivatable := true
@export var level: Level
@export var chargers: Array[Charger]
@export var head_sprite: Sprite2D

var deactivated := false
var all_chargers_deactivated := false


func _ready() -> void:
	head_sprite.material = head_sprite.material.duplicate()


func try_deactivate():
	if deactivatable:
		# Do not deactivate if chargers are not deactivated
		for charger in chargers:
			if !charger.deactivated: return

		deactivated = true


func catch_player():
	level.catch_player(self)


func _physics_process(_delta: float) -> void:
	# Draw charging line for each charger + check for all chargers deactivated
	for charger in chargers:
		charger.line.clear_points()

		charger.line.add_point(Vector2.ZERO)
		charger.line.add_point(global_position - charger.global_position)

		if !charger.deactivated: return
	
	all_chargers_deactivated = true
