extends Node
class_name StructureDeathComponent

@export var structure: StaticBody2D
@export var sprite_2d: Sprite2D
@export var health_component: HealthComponent
@export var score_value := 100

func _ready() -> void:
	health_component.died.connect(death)

func death() -> void:
	sprite_2d.set_deferred("visible", false)
	Ui.remove_player_health(1)
	structure.queue_free()
