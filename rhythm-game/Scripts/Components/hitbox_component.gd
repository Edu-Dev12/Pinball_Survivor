extends Area2D
class_name HitboxComponent

signal hit

@export var damage : int
@export var apply_ball_bounce: bool = false

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		area.hurt(damage, self)
		hit.emit()
