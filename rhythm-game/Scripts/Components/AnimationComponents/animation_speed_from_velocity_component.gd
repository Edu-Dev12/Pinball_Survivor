extends Node
class_name AnimationSpeedFromVelocityComponent

@export_custom(ETP.NONE, ETP.PROPERTY) var base_speed: float = 150.0
@export_custom(ETP.NONE, ETP.PROPERTY) var min_anim_speed: float = 0.2

@export_group("Components")
@export var rigid_body: RigidBody2D
@export var animated_sprite: AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	change_speed_animation()
	change_color_animation()
		
func change_speed_animation() -> void:
	if rigid_body and animated_sprite:
		var current_speed: float = rigid_body.linear_velocity.length()
		animated_sprite.speed_scale = max(min_anim_speed, current_speed / base_speed)
		
func change_color_animation() -> void:
	if rigid_body and animated_sprite:
		var current_speed: float = rigid_body.linear_velocity.length()
		
		## REMOVER ESSA VALOR ARBITRARIO
		if current_speed >= 1000.0:
			animated_sprite.modulate.b = 0
		else:
			animated_sprite.modulate.b = 1
