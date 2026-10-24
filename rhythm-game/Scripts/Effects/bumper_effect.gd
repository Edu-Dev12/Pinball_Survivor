extends Node2D

@onready var bumper_effect: GPUParticles2D = $BumperEffect

func _ready() -> void:
	bumper_effect.finished.connect(queue_free)
		
	bumper_effect.emitting = true
