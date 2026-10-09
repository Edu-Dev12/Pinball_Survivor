@icon("uid://bb0vc1otdxvrc")
extends Node2D
class_name Flipper

signal rotation_completed

@export var animated_sprite: AnimatedSprite2D
@export_custom(ETP.NONE, ETP.PROPERTY) var shake_intensity: float = 2.0
@export var pivot: Node2D
@export_custom(ETP.NONE, ETP.PROPERTY) var max_rotation_degrees: float = -45.0
@export_custom(ETP.NONE, ETP.PROPERTY) var fade_duration: float = 0.2
@export_custom(ETP.NONE, ETP.PROPERTY) var release_duration: float = 0.05

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
		_fade_in()
		
	var t = (current_charge - min_charge) / (max_charge - min_charge)
	t = clamp(t, 0.0, 1.0)
	
	_base_target_rotation = lerp(0.0, deg_to_rad(max_rotation_degrees), t)
	
	if t >= 1.0:
		_is_fully_charged = true
	else:
		_is_fully_charged = false
		if _tween == null or not _tween.is_running():
			pivot.rotation = _base_target_rotation

func animate_release() -> void:
	_is_fully_charged = false
	if _tween:
		_tween.kill()
		
	_tween = create_tween()
	
	if pivot:
		_tween.tween_property(pivot, "rotation", 0.0, release_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
	_tween.tween_callback(func(): rotation_completed.emit())
	_tween.tween_property(self, "modulate:a", 0.0, fade_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	await rotation_completed

func _fade_in() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "modulate:a", 1.0, fade_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
