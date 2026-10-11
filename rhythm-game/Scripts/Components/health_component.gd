extends Node
class_name HealthComponent

signal died

@export var max_health: int = 10
var current_health: int
var is_dead: bool = false

func _ready() -> void:
	current_health = max_health

func set_max_health(amount: int) -> void:
	max_health = amount
	
func set_health(amount: int) -> void:
	current_health = amount

func heal_health(heal_amount: int) -> void:
	current_health = min(max_health, current_health + heal_amount)

func receive_damage(damage_amount: int) -> void:
	current_health = max(0, current_health - damage_amount)
	if current_health <= 0:
		is_dead = true
		died.emit()
		
	
