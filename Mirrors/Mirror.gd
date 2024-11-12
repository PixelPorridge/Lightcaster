class_name Mirror
extends CharacterBody2D

@export_group("Nodes")
@export var holdable_area: Area2D
@export var void_check_area: Area2D
@export var sprite: Sprite2D
@export var collider: CollisionShape2D
@export var animation_tree: AnimationTree

@export_group("Settings")
@export var friction := 2.0

enum MirrorProximityState {
	FAR,
	CLOSE
}

var mirror_proximity_state := MirrorProximityState.FAR


func _physics_process(delta: float) -> void:
	velocity = velocity.lerp(Vector2.ZERO, friction * delta)

	var collision = move_and_collide(velocity * delta)

	if collision:
		velocity = velocity.bounce(collision.get_normal())
	
	if (velocity.length() < 5 && void_check_area.get_overlapping_bodies()):
		animation_tree["parameters/conditions/falling"] = true
		
		
func rotate_mirror(radians: float):
	sprite.rotate(radians)
	collider.rotate(radians)


func _on_holdable_area_entered(_area: Area2D) -> void:
	mirror_proximity_state = MirrorProximityState.CLOSE


func _on_holdable_area_exited(_area: Area2D) -> void:
	mirror_proximity_state = MirrorProximityState.FAR
