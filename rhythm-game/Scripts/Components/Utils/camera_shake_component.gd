extends Node2D
class_name CameraShakeComponent

@export var shake_enabled = true
@export var max_shake: float = 2.0
@export var shake_fade: float = 7.0
@export var camera: Camera2D

var shake_strength: float = 0.0
var current_fade: float = 7.0

func trigger_shake():
	shake_strength = max_shake
	current_fade = shake_fade

func trigger_shake_custom(custom_strength: float, custom_fade: float = 7.0):
	shake_strength = custom_strength
	current_fade = custom_fade

func _physics_process(delta: float) -> void:
	if shake_strength > 0 and shake_enabled:
		shake_strength = lerp(shake_strength, 0.0, current_fade * delta)
		camera.offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
	else:
		if camera and camera.offset != Vector2.ZERO:
			camera.offset = Vector2.ZERO
