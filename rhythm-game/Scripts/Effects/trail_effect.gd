extends Line2D

@export var trail_target: Node2D
@export var trail_length: int = 50
@export var min_distance: float = 2.0

func _ready() -> void:
	top_level = true
	clear_points()

func _process(_delta: float) -> void:
	if not trail_target: return
	
	var current_pos = trail_target.global_position
	
	if points.size() == 0:
		add_point(current_pos)
		return
		
	var last_point_pos = points[-1]
	if current_pos.distance_to(last_point_pos) > min_distance:
		add_point(current_pos)
		
	while points.size() > trail_length:
		remove_point(0)
