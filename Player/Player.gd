class_name Player
extends CharacterBody2D

@export_group("Nodes")
@export var sprite: Sprite2D
@export var flippable: Node2D
@export var target_sprite: Sprite2D
@export var trajectory_line: Line2D
@export var guides_animation_tree: AnimationTree
@export var holdable_check_area: Area2D
@export var holdable_position: Node2D
@export var level: Level

@export_group("Audio")
@export var audio_stream_player: AudioStreamPlayer2D

@export_group("Light")
@export var light_scene: PackedScene
@export var light_spawn_position: Node2D
@export var impact_scene: PackedScene

enum LightState {
	READY,
	AIMING
}

@export var light_state := LightState.READY

@export_group("Mirror")
@export var mirror: Mirror

@export_group("Movement")
@export var speed: float


func _physics_process(delta: float) -> void:
	# --- Movement ---

	var direction := Input.get_vector(InputMapActions.LEFT, InputMapActions.RIGHT, InputMapActions.UP, InputMapActions.DOWN)

	velocity.x = direction.x * speed;
	velocity.y = direction.y * speed;

	move_and_slide()

	# --- Sprite ---

	if direction.x > 0:
		flippable.scale.x = 1
	elif direction.x < 0:
		flippable.scale.x = -1
	
	# --- Shoot Light ---

	# Begin aiming light
	if Input.is_action_pressed(InputMapActions.SHOOT) && light_state == LightState.READY && !mirror && level.light_shots > 0:
		light_state = LightState.AIMING
		trajectory_line.visible = true

	# Shoot light after aimed
	if Input.is_action_just_released(InputMapActions.SHOOT) && light_state == LightState.AIMING && !mirror:

		# Instantiate light
		var light: Light = light_scene.instantiate()

		light.global_position = light_spawn_position.global_position
		light.look_at(get_global_mouse_position())

		get_tree().root.add_child(light)

		# Instantiate impact
		var impact: Node2D = impact_scene.instantiate()

		impact.global_position = light_spawn_position.global_position
		impact.global_rotation = randf() * 2 * PI

		get_tree().root.add_child(impact)

		# Play random shoot sound
		audio_stream_player.play()

		# Decrease level light shots available
		level.light_shots -= 1

		light_state = LightState.READY
		trajectory_line.visible = false

		
	# --- Holdable Mirrors ---

	# Pickup mirror
	if Input.is_action_just_pressed(InputMapActions.PICKUP) && !mirror:
		if holdable_check_area.get_overlapping_areas():
			mirror = holdable_check_area.get_overlapping_areas()[0].get_parent()
			mirror.holdable_area.set_collision_mask_value(CollisionLayers.PLAYER_HOLDABLE_CHECK_LAYER, false)

			light_state = LightState.AIMING
	
	# Rotate mirror
	if Input.is_action_pressed(InputMapActions.ROTATE_LEFT) && mirror:
		mirror.rotate_mirror(-2 * delta)
	
	# Rotate mirror
	if Input.is_action_pressed(InputMapActions.ROTATE_RIGHT) && mirror:
		mirror.rotate_mirror(2 * delta)
	
	# Throw mirror
	if Input.is_action_just_released(InputMapActions.PICKUP) && mirror:
		mirror.holdable_area.set_collision_mask_value(CollisionLayers.PLAYER_HOLDABLE_CHECK_LAYER, true)
		mirror.velocity = (get_global_mouse_position() - holdable_position.global_position) * 2

		# Limit velocity of throw
		if mirror.velocity.length() >= 200:
			mirror.velocity = mirror.velocity.normalized() * 200

		mirror = null

		light_state = LightState.READY

	# Lerp mirror to holding position
	if mirror:
		mirror.global_position = mirror.global_position.lerp(holdable_position.global_position, 30 * delta)


func _process(_delta: float) -> void:
	# Target cursor
	target_sprite.global_position = get_global_mouse_position()

	# Target spin time scale
	match light_state:
		LightState.READY:
			guides_animation_tree["parameters/BlendTree/SpinTimeScale/scale"] = 1.0 / 4
		LightState.AIMING:
			guides_animation_tree["parameters/BlendTree/SpinTimeScale/scale"] = 1.0
