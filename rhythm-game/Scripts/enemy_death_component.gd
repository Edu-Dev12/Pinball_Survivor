extends Node
class_name EnemyDeathComponent

const DEAD_BODY_EFFECT = preload("uid://u116yfkbse07")

@export var health_component: HealthComponent
@export var enemy: CharacterBody2D
@export var sprite_2d: Sprite2D

func _ready() -> void:
	health_component.died.connect(death)

func death() -> void:
	sprite_2d.set_deferred("visible", false)
	create_body_effect()
	enemy.queue_free()

func create_body_effect():
	var effect: DeadBodyEffect = DEAD_BODY_EFFECT.instantiate()
	var player = get_tree().get_first_node_in_group("Player")
	
	effect.sprite = sprite_2d.texture
	effect.new_scale = sprite_2d.scale
	effect.global_position = enemy.global_position
	
	var direction = (enemy.global_position - player.global_position).normalized()
	effect.emmit_direction = direction
	
	enemy.get_parent().add_child(effect)
