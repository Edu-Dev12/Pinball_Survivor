extends Special
class_name UpgradeLightningTesla

var player: PlayerBody
var rigidBody2D: RigidBody2D

var enemies_hurtbox: Array[HurtboxComponent] = []

@export var effects: Array[EffectData]

func _physics_process(_delta: float) -> void:
	if rigidBody2D:
		global_position = rigidBody2D.global_position

func use_special(playerBody: PlayerBody, rigidBody: RigidBody2D):
	player = playerBody
	rigidBody2D = rigidBody
	
	global_position = rigidBody2D.global_position
	
	shock_wave()

func shock_wave():
	create_effects()
	pass
	
func create_effects():
	var context: Dictionary = {
		"position": global_position,
	}
	
	GlobalEffectManagers.spawn_effects(effects, context)
	
func _enemies_on_area(area: HurtboxComponent):
	enemies_hurtbox.append(area)
