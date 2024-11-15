class_name Light
extends CharacterBody2D

@export_group("Impact")
@export var impact_scene: PackedScene

@export_group("LightGhost")
@export var light_ghost_scene: PackedScene

@export_group("Audio")
@export var audio_stream_player: AudioStreamPlayer2D

@export_group("Settings")
@export var speed: float


func _physics_process(delta: float) -> void:
	# --- Move Light ---

	velocity = Vector2(speed, 0).rotated(rotation)
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)

	# --- Collision Detection ---

	if collision:
		
		# Get collision layer bit
		var collision_layer_bitmask = PhysicsServer2D.body_get_collision_layer(collision.get_collider_rid())

		# Reflect light
		if collision_layer_bitmask == CollisionLayers.LIGHT_REFLECTOR_BITMASK:
			var reflect = collision.get_remainder().bounce(collision.get_normal())
			rotation = reflect.angle()

			# Instantiate impact
			var impact: Node2D = impact_scene.instantiate()

			impact.global_position = global_position
			impact.global_rotation = randf() * 2 * PI

			get_tree().current_scene.add_child(impact)
		
			# Play random sound
			audio_stream_player.play()
		
		# Stop light
		elif collision_layer_bitmask == CollisionLayers.LIGHT_BLOCKER_BITMASK:
			queue_free()
		
		# Try deactivate enemy
		elif collision_layer_bitmask == CollisionLayers.ENEMY_BITMASK:
			var enemy: Enemy = collision.get_collider()

			enemy.try_deactivate()

			queue_free()
		
	# Instantiate light ghost
	var light_ghost: Node2D = light_ghost_scene.instantiate()

	light_ghost.global_position = global_position
	light_ghost.global_rotation = global_rotation

	get_tree().current_scene.add_child(light_ghost)


func _on_lifetime_timer_timeout() -> void:
	queue_free()
