extends Node
class_name PlayerSpecialComponent

@export var player: PlayerBody
@export var rigidBody2D: RigidBody2D

@export var special: SpecialData
@export var special_scene: Special

func _ready() -> void:
	#conectar no signal global para set special
	GlobalInputManager.use_special.connect(use_special)
	pass
	
func set_special(special_ball: SpecialData):
	special = special_ball

	special_scene = special.special_scene.instantiate()
	add_child(special_scene)

func use_special():
	if special_scene:
		special_scene.use_special(player, rigidBody2D)
