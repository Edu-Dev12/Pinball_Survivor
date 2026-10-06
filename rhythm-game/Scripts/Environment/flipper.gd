@icon("uid://bb0vc1otdxvrc")
extends Node2D
class_name Flipper

@export var animated_sprite: AnimatedSprite2D
@export var shake_intensity: float = 2.0
@export var pivot: Node2D
@export var max_rotation_degrees: float = -45.0
@export var fade_duration: float = 0.2

var _is_fully_charged: bool = false
var _base_target_rotation: float = 0.0
var _tween: Tween

func _ready() -> void:
	modulate.a = 0.0

func _process(_delta: float) -> void:
	if _is_fully_charged and pivot:
		var shake_offset = randf_range(-shake_intensity, shake_intensity)
		pivot.rotation = _base_target_rotation + deg_to_rad(shake_offset)

func animate_charge(current_charge: float, min_charge: float, max_charge: float) -> void:
	if not pivot:
		return
		
	if current_charge == min_charge and (_tween == null or not _tween.is_running()):
		_fade(1.0)
		
	var t = (current_charge - min_charge) / (max_charge - min_charge)
	t = clamp(t, 0.0, 1.0)
	
	_base_target_rotation = lerp(0.0, deg_to_rad(max_rotation_degrees), t)
	
	if t >= 1.0:
		_is_fully_charged = true
	else:
		_is_fully_charged = false
		pivot.rotation = _base_target_rotation

func animate_release() -> void:
	_is_fully_charged = false
	if pivot:
		pivot.rotation = 0.0
	_fade(0.0)

func _fade(target_alpha: float) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "modulate:a", target_alpha, fade_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
