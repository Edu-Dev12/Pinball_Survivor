extends Line2D

@export var trail_target: Node2D
@export var trail_length: int = 50

func _ready() -> void:
	top_level = true
	clear_points()

func _process(_delta: float) -> void:
	if not trail_target: return
	
	add_point(trail_target.global_position)

	if points.size() > trail_length:
		remove_point(0)
