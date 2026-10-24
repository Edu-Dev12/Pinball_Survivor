extends Node
class_name EnemyDeathComponent

const DEAD_BODY_EFFECT = preload("uid://u116yfkbse07")

@export var enemy: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var health_component: HealthComponent
@export var score_value : int = 100
@export var score_effect_scene : PackedScene
@export var hit_effect_scene: PackedScene

func _ready() -> void:
	health_component.died.connect(death)

func death() -> void:
	animated_sprite_2d.set_deferred("visible", false)
	create_body_effect()
	Ui.add_score(score_value)
	create_score_effect()
	crete_hit_effect()
	enemy.queue_free()

func create_body_effect():
	var effect: DeadBodyEffect = DEAD_BODY_EFFECT.instantiate()
	var player = get_tree().get_first_node_in_group("Player")
	
	effect.sprite = animated_sprite_2d.sprite_frames.get_frame_texture(animated_sprite_2d.animation, animated_sprite_2d.frame)
	effect.new_scale = animated_sprite_2d.scale
	effect.global_position = enemy.global_position
	
	var direction = (enemy.global_position - player.global_position).normalized()
	effect.emmit_direction = direction
	
	enemy.get_parent().add_child(effect)

func create_score_effect():
	var score_effect = score_effect_scene.instantiate() as Node2D
	score_effect.global_position = enemy.global_position
	score_effect.score = score_value
	get_parent().get_parent().add_child(score_effect)

func crete_hit_effect():
	var hit_effect = hit_effect_scene.instantiate() as Node2D
	hit_effect.global_position = enemy.global_position
	get_parent().get_parent().add_child(hit_effect)
