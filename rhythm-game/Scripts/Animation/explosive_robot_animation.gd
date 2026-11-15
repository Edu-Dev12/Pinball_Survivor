@icon("res://Assets/Icon/node/components/icon-comp-person.svg")
extends Node
class_name ExplosiveRobotAnimation

var is_walking: bool = false
var is_charging: bool = false
var is_exploding: bool = false

@export var enemy_explode_state: EnemyExplodeState

func _ready() -> void:
	enemy_explode_state.is_charging.connect(func(): is_charging = true)
	enemy_explode_state.is_exploding.connect(func(): is_exploding = true)
