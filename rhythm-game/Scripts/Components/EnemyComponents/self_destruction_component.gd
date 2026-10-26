extends Node
class_name SelfDestructionComponent

signal is_charging
signal is_exploding

@export var lifetime: float = 3.0
@export var damage: int = 1
@export var animated_sprite_2d: AnimatedSprite2D
@export var enemy_navigation: EnemyNavigationComponent

const SELF_DESTRUCTION_AREA = preload("uid://b7a1ts5nj82lg")

var tween: Tween

func _ready() -> void:
	enemy_navigation.orbit_reached.connect(start_countdown)

func start_countdown() -> void:
	is_charging.emit()
	tween = create_tween()
	tween.tween_property(animated_sprite_2d, "modulate", Color(1, 0, 0, 1), lifetime)
	tween.tween_callback(explode)

func explode() -> void:
	
	is_exploding.emit()
	var explosion : HitboxComponent = SELF_DESTRUCTION_AREA.instantiate()
	explosion.damage = damage
	explosion.global_position = enemy_navigation.enemy.global_position
	explosion.is_temporary = true
	
	animated_sprite_2d.set_deferred("visible", false)
	enemy_navigation.enemy.get_parent().add_child(explosion)
	enemy_navigation.enemy.queue_free()
