extends Control
class_name UI

@onready var player_hp: Label = %PlayerHP
@onready var score_points: Label = %ScorePoints
@onready var timer_countdown: Label = %TimerCountdown

# --- PLAYER HP ---
func set_player_health(health: int) -> void:
	player_hp.text = str(health).pad_zeros(3)

# --- SCORE ---
func set_score(score: int) -> void:
	score_points.text = str(score).pad_zeros(6)

# --- TIMER (Formato MM:SS) ---
func set_time(total_seconds: int) -> void:
	var minutes := floori(total_seconds / 60.0)
	var seconds := total_seconds % 60
	timer_countdown.text = "%02d:%02d" % [minutes, seconds]
