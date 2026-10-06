extends Node
class_name RebounceBehaviorComponent

@export var rebounce_force:float = 120.0

@export var source: Node2D
@export var target: RigidBody2D

func _ready() -> void:
	if !target:
		target = get_tree().get_first_node_in_group(Global.PLAYER_GROUP)

func apply_rebounce():
	var current_speed: float = target.linear_velocity.length()
	var escape_direction: Vector2 = (target.global_position - source.global_position).normalized()
	
	var bonus_speed: float = rebounce_force
	var final_speed: float = current_speed + bonus_speed
	
	target.linear_velocity = escape_direction * final_speed
