extends Node
class_name AnimationSpeedFromVelocityComponent

@export var rigid_body: RigidBody2D
@export var animated_sprite: AnimatedSprite2D
@export var base_speed: float = 150.0
@export var min_anim_speed: float = 0.2

func _process(_delta: float) -> void:
	if rigid_body and animated_sprite:
		var current_speed: float = rigid_body.linear_velocity.length()
		animated_sprite.speed_scale = max(min_anim_speed, current_speed / base_speed)
