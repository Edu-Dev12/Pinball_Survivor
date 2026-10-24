extends Node
class_name PlayerStreakComponent

@export var streak_timeout: float = 4.0
@export var streak_multiplayer: float = 0.2
@export var max_streak: int = 10

var player_streak_kill: int = 0
var streak_timer: Timer

func _ready() -> void:
	streak_timer = Timer.new()
	streak_timer.one_shot = true
	streak_timer.wait_time = streak_timeout
	add_child(streak_timer)
	
	streak_timer.timeout.connect(_on_streak_timeout)

func add_kill() -> void:
	player_streak_kill = clampi(player_streak_kill + 1, 0, max_streak)
	
	streak_timer.start()
	
	print(player_streak_kill)

func _on_streak_timeout() -> void:
	player_streak_kill = 0
