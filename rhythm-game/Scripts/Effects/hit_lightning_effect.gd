extends Node2D

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

func _ready() -> void:
	gpu_particles_2d.emitting = true
	
	gpu_particles_2d.finished.connect(queue_free)
