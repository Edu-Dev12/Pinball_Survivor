extends Node2D

@onready var lightning_sphere: GPUParticles2D = $LightningSphere
@onready var lightning_particles: GPUParticles2D = $LightningParticles
@onready var lightning_flare: GPUParticles2D = $LightningFlare
@onready var wave_effect: GPUParticles2D = $WaveEffect

func _ready() -> void:
	lightning_sphere.emitting = true
	lightning_particles.emitting = true
	lightning_flare.emitting = true
	wave_effect.emitting = true
	
	lightning_particles.finished.connect(queue_free)
