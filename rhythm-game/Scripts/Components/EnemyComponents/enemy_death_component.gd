extends Node
class_name EnemyDeathComponent

const DEAD_BODY_EFFECT = preload("uid://u116yfkbse07")

@export var enemy: CharacterBody2D
@export var sprite_2d: Sprite2D
@export var health_component: HealthComponent
@export var score_value : int = 100
@export var score_effect_scene : PackedScene
@export var hit_effect_scene: PackedScene

func _ready() -> void:
	health_component.died.connect(death)

func death() -> void:
	sprite_2d.set_deferred("visible", false)
	
	var final_score = score_value
	var player_streak = get_tree().get_first_node_in_group(Global.PLAYER_STREAK_GROUP) as PlayerStreakComponent
	
	if player_streak:
		var bonus = 1.0 + (player_streak.player_streak_kill * player_streak.streak_multiplayer)
		final_score = int(score_value * bonus)
		player_streak.add_kill()
	
	Ui.add_score(final_score)
	create_body_effect()
	create_score_effect(final_score)
	crete_hit_effect()
	
	enemy.queue_free()

func create_body_effect():
	var effect: DeadBodyEffect = DEAD_BODY_EFFECT.instantiate()
	var player = get_tree().get_first_node_in_group(Global.PLAYER_BODY_GROUP)
	
	effect.sprite = sprite_2d.texture
	effect.new_scale = sprite_2d.scale
	effect.global_position = enemy.global_position
	
	var direction = (enemy.global_position - player.global_position).normalized()
	effect.emmit_direction = direction
	
	enemy.get_parent().add_child(effect)

func create_score_effect(final_score: int):
	var score_effect = score_effect_scene.instantiate() as Node2D
	score_effect.global_position = enemy.global_position
	score_effect.score = final_score
	get_parent().get_parent().add_child(score_effect)

func crete_hit_effect():
	var hit_effect = hit_effect_scene.instantiate() as Node2D
	hit_effect.global_position = enemy.global_position
	get_parent().get_parent().add_child(hit_effect)
