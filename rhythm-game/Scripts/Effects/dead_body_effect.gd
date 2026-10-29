extends Node2D
class_name DeadBodyEffect

@onready var body_texture: CPUParticles2D = $BodyTexture
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
var effect_direction: Vector2
var effect_sprite: Texture2D
var effect_scale: Vector2

func _ready() -> void:
	body_texture.direction = effect_direction
	body_texture.texture = effect_sprite
	body_texture.scale_amount_min = effect_scale.x
	body_texture.scale_amount_max = effect_scale.x
	body_texture.emitting = true
	
	var gpu_material = gpu_particles_2d.process_material as ParticleProcessMaterial
	gpu_material.direction = Vector3(effect_direction.x, effect_direction.y, 0)
	gpu_particles_2d.emitting = true
