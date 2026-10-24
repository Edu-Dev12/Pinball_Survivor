@icon("res://Assets/Icon/2d/office/icon-gamepad-2d.svg")
extends Node
class_name InputControllerComponent

@export var diagonal_tolerance_time: float = 0.08

var movement_vector: Vector2
var last_direction: Vector2 = Vector2.DOWN

var _is_diagonal: bool = false
var _diagonal_timer: float = 0.0
var _saved_diagonal: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	var raw_vector = Input.get_vector("Right", "Left", "Down", "Up")
	movement_vector = raw_vector
	
	if movement_vector != Vector2.ZERO:
		last_direction = movement_vector
		
		if abs(movement_vector.x) > 0.1 and abs(movement_vector.y) > 0.1:
			_is_diagonal = true
			_saved_diagonal = movement_vector
			_diagonal_timer = diagonal_tolerance_time
		else:
			if _is_diagonal and _diagonal_timer > 0.0:
				_diagonal_timer -= delta
			else:
				_is_diagonal = false
	else:
		if _is_diagonal and _diagonal_timer > 0.0:
			_diagonal_timer -= delta
		else:
			_is_diagonal = false

func get_input() -> Vector2:
	return movement_vector

func get_attack_direction() -> Vector2:
	if _is_diagonal and _diagonal_timer > 0.0:
		return _saved_diagonal
	return last_direction
