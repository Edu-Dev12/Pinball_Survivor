extends Node
class_name EnemyDeathComponent

const DEAD_BODY_EFFECT = preload("uid://u116yfkbse07")

@export var enemy: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var health_component: HealthComponent
@export var score_value : int = 100
@export var score_effect_scene : PackedScene
@export var hit_effect_scene: PackedScene

@export var effects: Array[EffectData]

var final_score: int = 0

func _ready() -> void:
	health_component.died.connect(death)

func death() -> void:
	animated_sprite_2d.set_deferred("visible", false)

	calculate_final_score()
	
	Ui.add_score(final_score)
	create_effects()
	
	if enemy.is_in_group(Global.BOSS_GROUP):
		SignalManager.level_won.emit()
	enemy.queue_free()

func create_effects():
	var context: Dictionary = {
		"position": enemy.global_position,
		"score": final_score,
		"direction": get_effect_direction(),
		"sprite": animated_sprite_2d.sprite_frames.get_frame_texture(animated_sprite_2d.animation, animated_sprite_2d.frame),
		"scale": animated_sprite_2d.scale,
		
	}
	
	GlobalEffectManagers.spawn_effects(effects, context)

func calculate_final_score():
	final_score = score_value
	var player_streak = get_tree().get_first_node_in_group(Global.PLAYER_STREAK_GROUP) as PlayerStreakComponent
	
	if player_streak:
		var bonus = 1.0 + (player_streak.player_streak_kill * player_streak.streak_multiplayer)
		final_score = int(score_value * bonus)
		player_streak.add_kill()

func get_effect_direction() -> Vector2:
	var player = get_tree().get_first_node_in_group(Global.PLAYER_BODY_GROUP)
	
	return (enemy.global_position - player.global_position).normalized()
