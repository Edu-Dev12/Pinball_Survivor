extends Node2D
class_name BPMControllerComponent

var tolerance_time_in: float = 0.15
var tolerance_time_out: float = 0.15
var on_beat: bool = false

func _ready() -> void:
	BpmManager.beat_triggered.connect(on_beat_triggered)

func _process(delta: float) -> void:
	if BpmManager.bpm == 0:
		return
		
	if BpmManager.beat_timer >= (BpmManager.time_per_beat - tolerance_time_in) and not on_beat:
		enable_beat()

func on_beat_triggered() -> void:
	if not on_beat:
		enable_beat()
	
	await get_tree().create_timer(tolerance_time_out).timeout
	
	on_beat = false

func enable_beat() -> void:
	on_beat = true

func consume_window() -> void:
	on_beat = false
