extends Node

signal beat_triggered

var bpm: int = 0
var time_per_beat: float = 0.0
var beat_timer: float = 0.0

func set_bpm(new_bpm: int): 
	bpm = new_bpm
	calculate_variables()

func _ready():
	set_bpm(50)

func _process(delta: float):
	if bpm == 0:
		return
		
	beat_timer += delta
	
	if beat_timer >= time_per_beat:
		trigger_beat()

func calculate_variables():
	time_per_beat = 60.0 / bpm
	beat_timer = 0.0

func trigger_beat():
	beat_timer -= time_per_beat
	print("--- BATIDA REAL DA MÚSICA ---")
	beat_triggered.emit()
