extends Node
class_name KnockbackComponent

@export var enemy: CharacterBody2D
@export var decay_rate: float = 1000.0
var knockback_velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	if not enemy:
		enemy = owner as CharacterBody2D

func apply_knockback(force: Vector2) -> void:
	knockback_velocity = force

func is_knockbacked() -> bool:
	return knockback_velocity != Vector2.ZERO

func _physics_process(delta: float) -> void:
	if knockback_velocity == Vector2.ZERO:
		return
	if not enemy:
		return
	enemy.velocity = knockback_velocity
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, delta * decay_rate)
	enemy.move_and_slide()
