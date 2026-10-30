extends Node

signal use_special

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("Special"):
		use_special.emit()
