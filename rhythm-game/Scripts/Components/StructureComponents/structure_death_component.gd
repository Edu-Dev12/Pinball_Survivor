extends Node
class_name StructureDeathComponent

@export var structure: StaticBody2D
@export var animatedSprite2D: AnimatedSprite2D
@export var health_component: HealthComponent
@export var score_value := 100

func _ready() -> void:
	health_component.died.connect(death)

func death() -> void:
	animatedSprite2D.set_deferred("visible", false)
	Ui.remove_player_health(1)
	structure.queue_free()
