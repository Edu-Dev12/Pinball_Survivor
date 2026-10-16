extends Area2D
class_name HitboxComponent

signal hit

@export var damage : int
@export var apply_ball_bounce: bool = false
@export var is_temporary: bool = false
@export var lifetime: float = 1.0

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	if is_temporary:
		await get_tree().create_timer(lifetime).timeout
		self.call_deferred("queue_free")

func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		area.hurt(damage, self)
		hit.emit()
