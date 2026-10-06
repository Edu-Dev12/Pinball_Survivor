extends Node

func hit_stop(freeze_time: float):
	Engine.time_scale = 0
	await get_tree().create_timer(freeze_time, true, false, true).timeout
	Engine.time_scale = 1
	
func slow_motion(slow_time: float, freeze_time: float):
	Engine.time_scale = slow_time
	await get_tree().create_timer(freeze_time, true, false, true).timeout
	Engine.time_scale = 1
