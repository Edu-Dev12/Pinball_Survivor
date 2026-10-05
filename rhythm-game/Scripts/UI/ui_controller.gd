extends CanvasLayer

#@onready var ui: UI = $UI_Controller/UI
#@onready var timer: Timer
#@onready var timer_enable := false
#
#func _ready() -> void:
	#set_player_health(100)
	#setup_timer()
	#set_inital_time(300)
#
## Player
#func set_player_health(new_player_health: int):
	#ui.set_player_health(new_player_health)
#
#func add_player_health(heal_health: int):
	#for i in range(heal_health):
		#ui.add_player_health(1)
		#await get_tree().create_timer(0.2).timeout
#
#func remove_player_health(damage_health: int):
	#var current_health = ui.remove_player_health(damage_health)
	#
	#if current_health <= 0:
		#stop_timer()
		#var player = get_tree().get_first_node_in_group("player")
		#player.death()
#
## Score
#func add_score(score: int):
	#ui.add_score(score)
#
## Timer
#func set_inital_time(new_time: int):
	#ui.set_time(new_time)
#
#func get_timer() -> int:
	#return ui.get_time()
#
#func setup_timer():
	#timer = Timer.new()
	#timer.wait_time = 1.0
	#timer.autostart = false
	#timer.timeout.connect(timer_timeout)
	#add_child(timer)
#
#func run_timer():
	#if timer.is_stopped():
		#timer.start()
#
#func stop_timer():
	#timer.stop()
	#
#
#func timer_timeout():
	#var current_time = ui.decrease_time(1)
			#
	#if current_time < 30:
		#pass
		## AudioManager.play_sound_effect(TIME_SFX, "SFX", -5, 1,1)
	#if current_time <= 0:
		#
		#var player = get_tree().get_first_node_in_group("player")
		#player.death()
		#Ui.stop_timer()
		 #
		#print("TEMPO ACABOU")
#
#func decrease_time(decrease_timer: int) -> int:
	#return ui.decrease_time(decrease_timer)
