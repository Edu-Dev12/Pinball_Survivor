extends Area2D
class_name HurtboxComponent

signal was_hurt()

@export var health_component : HealthComponent

func hurt(damage: int) -> void:
	if health_component:
		health_component.receive_damage(damage)
		
	was_hurt.emit()
