extends Node
class_name PlayerSpecialComponent

@export var special: SpecialData


var special_scene: Special

func _ready() -> void:
	#conectar no signal global para set special
	GlobalInputManager.use_special.connect(use_special)
	pass
	
func set_special(special_ball: SpecialData):
	special = special_ball

	special_scene = special.special_scene.instantiate()
	add_child(special_scene)

func use_special():
	special_scene.use_special()
