class_name EnemyLight
extends PointLight2D

@export var ignore_walls := false
@export var enemy: Enemy
@export var ray_casts: Array[RayCast2D]


func _ready() -> void:
	if !ignore_walls: return

	# Disable shadows
	shadow_enabled = false

	# Disable wall collision for raycasts
	for ray_cast in ray_casts:
		ray_cast.set_collision_mask_value(CollisionLayers.DETECTOR_BLOCKER_LAYER, false)
		

func _physics_process(_delta: float) -> void:
	# Check for collision with each raycast
	for ray_cast in ray_casts:
		# Check if colliding object is player
		if ray_cast.is_colliding() && ray_cast.get_collider().get_parent() is Player:
			# Get player from collider
			var player: Player = ray_cast.get_collider().get_parent()

			# Disable player input
			player.input_enabled = false

			# Disable player detection area layer so it can't be detected again
			player.detection_area.set_collision_layer_value(CollisionLayers.PLAYER_DETECTION_LAYER, false)

			# Enemy handles catching of player
			enemy.catch_player()
			
			break


func disable_raycasts():
	for ray_cast in ray_casts:
		ray_cast.enabled = false
