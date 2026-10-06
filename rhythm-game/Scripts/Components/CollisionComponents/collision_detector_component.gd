@icon("res://Assets/Icon/2d/blocks/icon-block-container-2d.svg")
extends Node2D
class_name CollisionDetectorComponent

@export var rigidBody2D: RigidBody2D

func _ready() -> void:
	if rigidBody2D:
		rigidBody2D.contact_monitor = true
		rigidBody2D.max_contacts_reported = 20
		rigidBody2D.body_entered.connect(get_collision)

func get_collision(body: Node):
	if body.is_in_group(Global.ENEMY_GROUP):
		var current_speed: float = rigidBody2D.linear_velocity.length()
		var escape_direction: Vector2 = (rigidBody2D.global_position - body.global_position).normalized()
		
		var bonus_speed: float = 120.0
		var final_speed: float = current_speed + bonus_speed
		
		rigidBody2D.linear_velocity = escape_direction * final_speed
		body.die_by_player()
