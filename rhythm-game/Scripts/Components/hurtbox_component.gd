extends Area2D
class_name HurtboxComponent

@export var health_component : HealthComponent

func _ready() -> void:
	body_entered.connect(hurt)

func hurt(body: Node2D) -> void:
	if body is HitboxComponent:
		health_component.damage_taken.emit(body.damage)
