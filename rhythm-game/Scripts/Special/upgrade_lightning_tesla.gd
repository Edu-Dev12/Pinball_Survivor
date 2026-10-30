extends Node2D
class_name UpgradeLightningTesla

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("Special"):
		shock_wave()

func shock_wave():
	pass
