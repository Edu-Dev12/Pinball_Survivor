extends Node2D
@onready var body_texture: CPUParticles2D = $BodyTexture

var emmit_direction: Vector2

func _ready() -> void:
	body_texture.direction = emmit_direction
	
	body_texture.emitting = true
