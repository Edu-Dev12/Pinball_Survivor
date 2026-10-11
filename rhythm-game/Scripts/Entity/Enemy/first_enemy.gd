extends CharacterBody2D

@export var healthComponent: HealthComponent

func _ready() -> void:
	healthComponent.died.connect(_die)

func _die():
	queue_free()
