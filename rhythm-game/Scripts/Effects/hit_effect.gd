extends Node2D

@onready var hit_effect: GPUParticles2D = $HitEffect

func _ready() -> void:
	hit_effect.finished.connect(queue_free)
	hit_effect.emitting = true
