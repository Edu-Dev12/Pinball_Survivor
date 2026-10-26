extends Node2D
class_name DeadBodyEffect

@onready var body_texture: CPUParticles2D = $BodyTexture
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
var emmit_direction: Vector2
var sprite: Texture2D
var new_scale: Vector2

func _ready() -> void:
	body_texture.direction = emmit_direction
	body_texture.texture = sprite
	body_texture.scale_amount_min = new_scale.x
	body_texture.scale_amount_max = new_scale.x
	body_texture.emitting = true
	
	var gpu_material = gpu_particles_2d.process_material as ParticleProcessMaterial
	gpu_material.direction = Vector3(emmit_direction.x, emmit_direction.y, 0)
	gpu_particles_2d.emitting = true
