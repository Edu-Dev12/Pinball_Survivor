extends BaseLevel
class_name RunOverLevel

@onready var run_over_label = $%RunOverLabel
@onready var try_again_button = $%TryAgain
@onready var close_game_button = $%CloseGame
@onready var score_value = $%ScoreValue

func _ready() -> void:
	run_over_label.text = "Game Over..." if Ui.current_health <= 0 else "Victory!"
	score_value.text = str(Ui.current_score)
	Ui.disable_ui()
	
	try_again_button.pressed.connect(try_again)
	close_game_button.pressed.connect(close_game)

func try_again() -> void:
	Ui.restart_ui()
	SignalManager.next_level_reached.emit(next_level)

func close_game() -> void:
	get_tree().quit()
