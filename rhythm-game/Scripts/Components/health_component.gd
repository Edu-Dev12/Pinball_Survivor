extends Node2D
class_name HealthComponent

signal damage_taken(damage: int)

@export var max_health: int = 10
@export var current_health: int = 10
@export var is_dead: bool = false

func _ready() -> void:
	current_health = max_health
	damage_taken.connect(receive_damage)

func set_health(amount: int) -> void:
	current_health = amount

func heal_health(heal_amount: int) -> void:
	for i in range(heal_amount):
		current_health += 1

func receive_damage(damage_amount: int) -> void:
	current_health = max(0, current_health - damage_amount)
	print("a")
	if current_health <= 0:
		is_dead = true
