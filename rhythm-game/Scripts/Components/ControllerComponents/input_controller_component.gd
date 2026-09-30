extends Node2D
class_name InputControllerComponent

var movement_vector: Vector2

var _input_history: Array[Vector2] = []
const BUFFER_SIZE: int = 6

func _unhandled_input(_event: InputEvent) -> void:
	movement_vector = Input.get_vector("Left", "Right", "Up", "Down")
	
	if movement_vector != Vector2.ZERO:
		_input_history.append(movement_vector)
		if _input_history.size() > BUFFER_SIZE:
			_input_history.remove_at(0)

func get_best_buffered_direction(fallback_direction: Vector2) -> Vector2:
	if _input_history.is_empty():
		return fallback_direction
		
	var best_dir: Vector2 = fallback_direction
	var max_diagonal_score: float = -1.0
	
	for dir in _input_history:
		var score: float = abs(dir.x) * abs(dir.y)
		if score > max_diagonal_score:
			max_diagonal_score = score
			best_dir = dir.normalized()
			
	_input_history.clear()
	return best_dir
