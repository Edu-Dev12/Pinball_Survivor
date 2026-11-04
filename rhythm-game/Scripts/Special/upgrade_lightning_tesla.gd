extends Special
class_name UpgradeLightningTesla

@onready var collision_shape_2d: CollisionShape2D = $HitboxComponent/CollisionShape2D

var player: PlayerBody
var rigidBody2D: RigidBody2D


@export var effects: Array[EffectData]
@export var enemt_hit_effects: Array[EffectData]

func use_special(playerBody: PlayerBody, rigidBody: RigidBody2D):
	player = playerBody
	rigidBody2D = rigidBody
	
	global_position = rigidBody2D.global_position
	
	shock_wave()

func shock_wave():
	var camera = get_tree().get_first_node_in_group(Global.CAMERA_GROUP)
	if camera and camera.has_node("CameraShakeComponent"):
		camera.cameraShakeComponent.trigger_shake()
			
	create_effects()
	
	await get_tree().create_timer(0.1).timeout
	collision_shape_2d.set_deferred("disabled", false)
	await get_tree().create_timer(0.6).timeout
	collision_shape_2d.set_deferred("disabled", true)
	
func create_effects():
	var context: Dictionary = {
		"position": global_position,
	}
	
	GlobalEffectManagers.spawn_effects(effects, context)
	
func _enemies_on_area(area: HurtboxComponent):
	var context: Dictionary = {
		"position": area.global_position,
	}
	
	GlobalEffectManagers.spawn_effects(enemt_hit_effects, context)
