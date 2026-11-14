extends Resource
class_name PlayerLevelAction

enum LEVEL_ACTION {
	BALL_CHOISE,
	RECEIVE_UPGRADE_POINT
}

@export var action: LEVEL_ACTION = LEVEL_ACTION.BALL_CHOISE
@export var starts: int = 1
@export var frequency: int = 1
