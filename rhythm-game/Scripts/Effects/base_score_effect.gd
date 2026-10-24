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

@onready var label: Label = $Label
var score: int = 0

func _ready() -> void:
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
