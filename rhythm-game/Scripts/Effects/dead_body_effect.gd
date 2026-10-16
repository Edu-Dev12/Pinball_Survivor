extends Node2D
class_name DeadBodyEffect

@onready var body_texture: CPUParticles2D = $BodyTexture
var emmit_direction: Vector2
var sprite: Texture2D
var new_scale: Vector2

func _ready() -> void:
	body_texture.direction = emmit_direction
	body_texture.texture = sprite
	body_texture.scale = new_scale
	body_texture.emitting = true
