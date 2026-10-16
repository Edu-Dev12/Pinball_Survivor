extends CharacterBody2D

@export var healthComponent: HealthComponent
var target: Node2D

var structure_list: Array

@export var speed: float = 100.0
@export var lifetime: float = 15.0

func _ready() -> void:
	healthComponent.died.connect(_die)

func _physics_process(_delta: float) -> void:
		move_and_slide()
		
func _die():
	queue_free()
