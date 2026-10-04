@icon("uid://bb0vc1otdxvrc")
extends Node2D
class_name Flipper

@export var animated_sprite: AnimatedSprite2D
@export var shake_intensity: float = 2.0

var is_charging: bool = false

func _ready() -> void:
	if animated_sprite:
		animated_sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(_delta: float) -> void:
	if is_charging and animated_sprite:
		animated_sprite.offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)

func start_charging(hit_direction: Vector2) -> void:
	update_flipper_rotation(hit_direction)
	
	if not is_charging:
		is_charging = true
		if animated_sprite:
			animated_sprite.play("charging")

func play_release_fx(hit_direction: Vector2) -> AnimatedSprite2D:
	is_charging = false
	update_flipper_rotation(hit_direction)
	
	if animated_sprite:
		animated_sprite.offset = Vector2.ZERO
		animated_sprite.play("release")
	
	return animated_sprite

func update_flipper_rotation(hit_direction: Vector2) -> void:
	if hit_direction != Vector2.ZERO:
		self.rotation = (-hit_direction).angle() + deg_to_rad(-90)

func _on_animation_finished() -> void:
	if animated_sprite and animated_sprite.animation == "release":
		animated_sprite.play("default")
