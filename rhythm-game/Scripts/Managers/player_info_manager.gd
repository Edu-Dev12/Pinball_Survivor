extends Node

var upgrade_points: int = 0
var balls_data: Array[BallData] = []
var selected_ball: BallData

signal selected_ball_changed(selected_ball: BallData)

func _ready() -> void:
	PlayerLevelManager.upgrade_point.connect(add_upgrade_points)

func reset_data():
	upgrade_points = 0
	balls_data = []
	selected_ball = null
#--------------------------------
# UPGRADE POINTS
#--------------------------------

func add_upgrade_points() -> void:
	upgrade_points += 1
	
func remove_upgrade_points() -> void:
	upgrade_points = maxi(0, upgrade_points - 1)

#--------------------------------
# SELECTED BALL
#-------------------------------- 
func change_selected_ball(new_selected_ball: BallData):
	selected_ball = new_selected_ball
	selected_ball_changed.emit(selected_ball)

#--------------------------------
# BALLS MANAGEMENT
#--------------------------------
func add_ball(ball_type: BallTypeData) -> void:
	for ball in balls_data:
		if ball.ball_type.ball_type == ball_type.ball_type:
			return
			
	var new_ball := BallData.new()
	new_ball.ball_type = ball_type
	balls_data.append(new_ball)
	
func remove_ball(ball_type: BallTypeData) -> void:
	for i in range(balls_data.size()):
		if balls_data[i].ball_type.ball_type == ball_type.ball_type:
			balls_data.remove_at(i)
			return

func add_special(ball_type: BallTypeData, special: SpecialData) -> void:
	for ball in balls_data:
		if ball.ball_type.ball_type == ball_type.ball_type:
			ball.ball_special = special
			return
	
func remove_special(ball_type: BallTypeData) -> void:
	for ball in balls_data:
		if ball.ball_type.ball_type == ball_type.ball_type:
			ball.ball_special = null
			return
