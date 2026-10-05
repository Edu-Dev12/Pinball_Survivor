extends CanvasLayer

@onready var ui: UI = $UIController/UI

var current_health: int = 100
var current_score: int = 0
var current_time: int = 300

var timer: Timer

func _ready() -> void:
	setup_timer()
	set_player_health(100)
	set_initial_time(300)
	add_score(0)
	run_timer()

# --- PLAYER ---
func set_player_health(amount: int) -> void:
	current_health = amount
	ui.set_player_health(current_health)

func add_player_health(heal_amount: int) -> void:
	for i in range(heal_amount):
		current_health += 1
		ui.set_player_health(current_health)
		await get_tree().create_timer(0.2).timeout

func remove_player_health(damage_amount: int) -> void:
	current_health = max(0, current_health - damage_amount)
	ui.set_player_health(current_health)
	
	if current_health <= 0:
		kill_player()

# --- SCORE ---
func add_score(amount: int) -> void:
	current_score += amount
	ui.set_score(current_score)

# --- TIMER ---
func setup_timer() -> void:
	timer = Timer.new()
	timer.wait_time = 1.0
	timer.autostart = false
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func set_initial_time(seconds: int) -> void:
	current_time = seconds
	ui.set_time(current_time)

func run_timer() -> void:
	if timer.is_stopped():
		timer.start()

func stop_timer() -> void:
	timer.stop()

func _on_timer_timeout() -> void:
	current_time -= 1
	ui.set_time(current_time)
	
	if current_time < 30:
		pass # AudioManager.play_sound_effect(TIME_SFX, "SFX", -5, 1, 1)
		
	if current_time <= 0:
		kill_player()

# --- AUXILIAR ---
func kill_player() -> void:
	stop_timer()
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("death"):
		player.death()
