extends Node
class_name WhiteHitEffect

const WHITE_HIT : ShaderMaterial = preload("uid://2fm1x1kgwske")

@export var animated_sprite: AnimatedSprite2D
@export var hurt_box: HurtboxComponent
@export var hit_duration: float = 0.3

func _ready() -> void:
	hurt_box.was_hurt.connect(hit_effect)
	
func hit_effect(_hit_box: HitboxComponent):
	var local_material = WHITE_HIT.duplicate()
	animated_sprite.material = local_material
	
	local_material.set_shader_parameter("Intensity", 1.0)
	
	var tween = create_tween()
	tween.tween_property(local_material, "shader_parameter/Intensity", 0.0, hit_duration)
	
	await tween.finished
	animated_sprite.material = null
	
	
