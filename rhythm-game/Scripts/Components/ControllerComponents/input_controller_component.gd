extends Node2D
class_name InputControllerComponent

var movement_vector: Vector2

func _unhandled_input(_event: InputEvent) -> void:
	
	movement_vector = Input.get_vector("Left", "Right", "Up", "Down")
	
	#print(movement_vector)
