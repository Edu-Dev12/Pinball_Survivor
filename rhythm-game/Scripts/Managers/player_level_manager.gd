extends Node

@export var start_required_score: int = 10000
@export var required_score_increase_percent: float = 10.0
@export var actions: Array[PlayerLevelAction]

var current_level_score: int = 0
var next_level_score: int
var current_level: int = 1

signal upgrade_point
signal ball_choise

func _ready() -> void:
	next_level_score = start_required_score

func add_score_to_level(score: int) -> void:
	current_level_score += score
	
	while current_level_score >= next_level_score:
		current_level_score -= next_level_score
		check_actions()
		current_level += 1
		
		print("\nPLAYER LEVEL: " + str(current_level))
		var multiplier: float = 1.0 + (required_score_increase_percent / 100.0)
		next_level_score = roundi(next_level_score * multiplier)


func check_actions() -> void:
	for action_item in actions:
		if action_item != null and action_item.check_and_trigger(current_level):
			execute_action(action_item.action)

func execute_action(action: PlayerLevelAction.LEVEL_ACTION) -> void:
	if action == PlayerLevelAction.LEVEL_ACTION.BALL_CHOISE:
		ball_choise.emit()
	if action == PlayerLevelAction.LEVEL_ACTION.UPGRADE_POINT:
		upgrade_point.emit()
