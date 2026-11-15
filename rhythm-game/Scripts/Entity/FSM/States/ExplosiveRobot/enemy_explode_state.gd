extends EnemyState
class_name EnemyExplodeState

signal is_charging
signal is_exploding

const SELF_DESTRUCTION_AREA = preload("uid://b7a1ts5nj82lg")

@export var lifetime: float = 3.0
@export var damage: int = 1
var tween: Tween

func enter() -> void:
	start_countdown()

func start_countdown() -> void:
	is_charging.emit()
	if not animated_sprite:
		return
	tween = create_tween()
	tween.tween_property(animated_sprite, "modulate", Color(1, 0, 0, 1), lifetime)
	tween.tween_callback(explode)

func explode() -> void:
	is_exploding.emit()
	if not character:
		return
	
	var explosion: HitboxComponent = SELF_DESTRUCTION_AREA.instantiate()
	explosion.damage = damage
	explosion.global_position = character.global_position
	explosion.is_temporary = true
	
	if animated_sprite:
		animated_sprite.set_deferred("visible", false)
		
	character.get_parent().add_child(explosion)
	character.queue_free()

func exit() -> void:
	if tween and tween.is_valid():
		tween.kill()
