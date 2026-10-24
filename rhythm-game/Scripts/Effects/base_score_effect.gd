extends Node2D

@export var speed: float = 0.6
@export var vertical_travel: float = -50.0
@export var min_x_offset: float = -20.0
@export var max_x_offset: float = 20.0
@export var min_rotation: float = -0.5
@export var max_rotation: float = 0.5
@export var start_scale: Vector2 = Vector2(0.3, 0.3)
@export var peak_scale: Vector2 = Vector2(1.3, 1.3)
@export var final_scale: Vector2 = Vector2(1.0, 1.0)

@export var base_color: Color = Color.WHITE
@export var max_streak_color: Color = Color.RED

@export var max_shake_rate: float = 30.0
@export var max_shake_level: float = 15.0

@onready var label: RichTextLabel = $Label
var score: int = 0

func _ready() -> void:
	var player_streak = get_tree().get_first_node_in_group(Global.PLAYER_STREAK_GROUP) as PlayerStreakComponent
	if player_streak:
		var current: float = float(player_streak.player_streak_kill)
		var max_s: float = float(player_streak.max_streak)
		
		var streak_percentage: float = clampi(current, 0, max_s) / max_s
		label.modulate = base_color.lerp(max_streak_color, streak_percentage)
		
		var multiplier: float = remap(current, 0.0, max_s, 1.0, 2.0)
		start_scale *= multiplier
		peak_scale *= multiplier
		final_scale *= multiplier
		
		if current > 0:
			var current_rate = remap(current, 1.0, max_s, 5.0, max_shake_rate)
			var current_level = remap(current, 1.0, max_s, 2.0, max_shake_level)
			label.text = "[shake rate=" + str(current_rate) + " level=" + str(current_level) + "]" + str(score) + "[/shake]"
		else:
			label.text = str(score)
	else:
		label.text = str(score)

	scale = start_scale

	var random_x = randf_range(min_x_offset, max_x_offset)
	var target_position = position + Vector2(random_x, vertical_travel)
	var target_rotation = randf_range(min_rotation, max_rotation)

	var tween = create_tween().set_parallel(true)
	
	tween.tween_property(self, "position", target_position, speed).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rotation", target_rotation, speed).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0.0, speed).set_trans(Tween.TRANS_LINEAR)
	
	var scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", peak_scale, speed * 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	scale_tween.tween_property(self, "scale", final_scale, speed * 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.chain().tween_callback(queue_free)
