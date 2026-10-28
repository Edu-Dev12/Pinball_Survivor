extends CharacterBody2D
class_name BossOVNI

@export_group("Boss_Resources")
@export var animated_sprite_2d: AnimatedSprite2D
@export var hurtbox : HurtboxComponent

@export_group("Boss_Traits")
@export var speed: float = 150.0
@export var scale_decrease_factor: float = 0.9  # Reduz 10% do tamanho a cada hit
@export var speed_multiplier: float = 1.1       # Aumenta 10% da velocidade a cada hit
@export var min_scale: float = 0.1

func _ready() -> void:
	hurtbox.was_hurt.connect(boss_hurt)

func boss_hurt(_hitbox: HitboxComponent) -> void:
	var tween = create_tween()
	var new_scale = max(scale.x * scale_decrease_factor, min_scale)
	tween.tween_property(self, "scale", Vector2(new_scale, new_scale), 0.2)
	speed *= speed_multiplier
