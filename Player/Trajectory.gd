extends Line2D

@export var collider: CharacterBody2D
@export var max_points: int
@export var speed: float


func _physics_process(delta: float) -> void:
	
	# Reset points
	clear_points()

	# Reset collider position and rotation
	collider.position = Vector2.ZERO

	# Rotate collider to look at mouse position
	collider.look_at(get_global_mouse_position())
	
	# Add point at next position
	add_point(collider.position)
	
	# Create new points
	for i in max_points:

		# Calculate velocity vector based on rotation
		var velocity := Vector2(speed, 0).rotated(collider.rotation)

		# Detect collision
		var collision: KinematicCollision2D = collider.move_and_collide(velocity * delta)

		# Reflect trajectory on collision
		if collision:
			var reflect = collision.get_remainder().bounce(collision.get_normal())
			collider.rotation = reflect.angle()
		
			# Get collision layer bit
			var collision_layer_bitmask = PhysicsServer2D.body_get_collision_layer(collision.get_collider_rid())

			# Stop trajectory
			if collision_layer_bitmask == CollisionLayers.LIGHT_BLOCKER_BITMASK:
				break
		
		# Add point at next position
		add_point(collider.position)
