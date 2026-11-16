extends Node

var upgrade_points: int = 0
var balls_data: Array[BallData] = []

func _ready() -> void:
	PlayerLevelManager.upgrade_point.connect(add_upgrade_points)

#--------------------------------
# UPGRADE POINTS
#--------------------------------

func add_upgrade_points() -> void:
	upgrade_points += 1
	
func remove_upgrade_points() -> void:
	upgrade_points = maxi(0, upgrade_points - 1)
	
#--------------------------------
# BALL MANAGEMENT
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
