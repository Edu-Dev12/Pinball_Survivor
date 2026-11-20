extends Resource
class_name PlayerLevelAction

enum LEVEL_ACTION {
	BALL_CHOISE,
	UPGRADE_POINT
}

@export var action: LEVEL_ACTION = LEVEL_ACTION.BALL_CHOISE
@export var starts: int = 1
@export var frequency: int = 1

func check_and_trigger(current_level: int) -> bool:
	if current_level < starts:
		return false
		
	if frequency <= 0:
		return current_level == starts
		
	return (current_level - starts) % frequency == 0
