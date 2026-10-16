extends Area2D
class_name HurtboxComponent

signal was_hurt(hitbox: HitboxComponent)

@export var health_component : HealthComponent

func hurt(damage: int, hitbox: HitboxComponent) -> void:
	if health_component:
		health_component.receive_damage(damage)
	was_hurt.emit(hitbox)
