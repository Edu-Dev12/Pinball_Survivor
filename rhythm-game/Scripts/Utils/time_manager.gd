extends Node

var cascade_level: int = 0
var cascade_timer: SceneTreeTimer = null

func hit_stop(freeze_time: float):
	Engine.time_scale = 0
	await get_tree().create_timer(freeze_time, true, false, true).timeout
	Engine.time_scale = 1
	
func slow_motion(slow_time: float, freeze_time: float):
	Engine.time_scale = slow_time
	await get_tree().create_timer(freeze_time, true, false, true).timeout
	Engine.time_scale = 1
	
func slow_motion_cascade():
	cascade_level += 1
	
	var base_slow: float = 0.9
	var target_time_scale: float = max(0.3, base_slow - (cascade_level * 0.10))
	
	Engine.time_scale = target_time_scale
	
	var current_timer_id: int = cascade_level
	cascade_timer = get_tree().create_timer(0.3, true, false, true)
	
	await cascade_timer.timeout
	
	if cascade_level == current_timer_id:
		cascade_level = 0
		Engine.time_scale = 1.0
