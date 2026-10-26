extends Node2D

@onready var bumper_effect: GPUParticles2D = $BumperEffect
@onready var bumper_effect_2: GPUParticles2D = $BumperEffect2

func _ready() -> void:
	bumper_effect.finished.connect(queue_free)
		
	bumper_effect.emitting = true
	bumper_effect_2.emitting = true
