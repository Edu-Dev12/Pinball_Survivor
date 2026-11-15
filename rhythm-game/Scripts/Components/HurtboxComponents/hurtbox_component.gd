extends Area2D
class_name HurtboxComponent

signal was_hurt(hitbox: HitboxComponent)

@export var health_component : HealthComponent
@export var is_active : bool = true

func hurt(damage: int, hitbox: HitboxComponent) -> void:
	if is_active:
		if health_component:
			health_component.receive_damage(damage)
		was_hurt.emit(hitbox)

func set_active_state(state: bool) -> void:
	self.is_active = state
