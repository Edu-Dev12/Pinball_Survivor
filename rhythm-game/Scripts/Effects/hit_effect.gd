extends Node2D

@onready var hit_effect: GPUParticles2D = $HitEffect

func _ready() -> void:
	hit_effect.finished.connect(queue_free)
	
	var player_streak = get_tree().get_first_node_in_group(Global.PLAYER_STREAK_GROUP) as PlayerStreakComponent
	if player_streak:
		var streak_factor: float = 1.0 + (player_streak.player_streak_kill * 0.1)
		scale *= streak_factor
		
	hit_effect.emitting = true
