extends Special
class_name UpgradeLightningTesla

@export var specialArea: Area2D
var player: PlayerBody
var rigidBody2D: RigidBody2D

var enemies_hurtbox: Array[HurtboxComponent]

func _physics_process(_delta: float) -> void:
	if rigidBody2D:
		#global_position = rigidBody2D.global_position
		pass

func use_special(playerBody: PlayerBody, rigidBody: RigidBody2D):
	player = playerBody
	rigidBody2D = rigidBody
	
	global_position = rigidBody2D.global_position
	
	shock_wave()

func shock_wave():
	print(global_position)
	print("CHAMA NO RAIO")
	pass
	
func _enemies_on_area(area: HurtboxComponent):
	enemies_hurtbox.append(area)
	area.hurt(50, null)
