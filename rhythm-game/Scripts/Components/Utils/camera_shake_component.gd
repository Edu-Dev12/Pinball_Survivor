extends Node2D
class_name CameraShakeComponent

@export var shake_enabled = true
@export var max_shake: float = 2.0
@export var shake_fade: float = 7.0

@export var camera: Camera2D

var shake_strength: float = 0.0

func trigger_shake():
	shake_strength = max_shake
	
func _physics_process(delta: float) -> void:
	if shake_strength > 0 and shake_enabled:
		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)
		camera.offset = Vector2(randf_range(-shake_strength,shake_strength), randf_range(-shake_strength,shake_strength))
