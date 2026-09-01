extends Node2D
class_name PlayerInputComponent

var movement_vector: Vector2
var is_dashing: bool

func get_movement_input() -> Vector2:
	movement_vector = Input.get_vector("Left", "Right", "Up", "Down", 0.3).round()
	
	return movement_vector.normalized()

func get_dash_input() -> bool:
	is_dashing = Input.is_action_just_pressed("Dash")
	
	return is_dashing

func is_receiving_movement_input() -> bool:
	return get_movement_input() != Vector2.ZERO
