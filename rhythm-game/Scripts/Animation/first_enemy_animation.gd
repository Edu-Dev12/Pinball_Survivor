@icon("res://Assets/Icon/node/components/icon-comp-person.svg")
extends Node
class_name FirstEnemyAnimation

var is_walking: bool = false
var is_charging: bool = false
var is_exploding: bool = false

@export var selfDestructionComponent: SelfDestructionComponent

func _ready() -> void:
	selfDestructionComponent.is_charging.connect(func(): is_charging = true)
	selfDestructionComponent.is_exploding.connect(func(): is_exploding = true)
