extends Node2D
class_name CollisionDetectorComponent

@export var rigidBody2D: RigidBody2D

func _ready() -> void:
	if rigidBody2D:
		rigidBody2D.contact_monitor = true
		rigidBody2D.max_contacts_reported = 20
		rigidBody2D.body_entered.connect(get_collision)

func get_collision(body: Node):
	if body is CharacterBody2D:
		var bounce_force: float = rigidBody2D.linear_velocity.length()
		var impact_normal: Vector2 = (global_position - body.global_position).normalized()
		rigidBody2D.linear_velocity = impact_normal * bounce_force
	
	if body.is_in_group(Global.ENEMY_GROUP):
		body.queue_free()
