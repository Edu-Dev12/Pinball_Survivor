extends BaseLevel
class_name Level1

func _ready() -> void:
	AudioManager.change_current_music(Global.BGM_SPACE_CADET_PINBALL)
	super()
