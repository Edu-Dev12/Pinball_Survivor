extends Area2D
class_name HurtboxComponent

@export var health_component : HealthComponent

func hurt(damage: int) -> void:
	health_component.receive_damage(damage)
