extends CharacterBody2D
class_name Player

@export_subgroup("Movement")
@export var linearVelocityComponent: LinearVelocityComponent

@export_subgroup("Controller")
@export var playerInputComponent: PlayerInputComponent

func _physics_process(delta: float) -> void:
	if  !playerInputComponent.is_dashing:
		if playerInputComponent.is_receiving_movement_input():
			linearVelocityComponent.apply_velocity(playerInputComponent.get_movement_input(), 200)
		else:
			linearVelocityComponent.stop_movement()
		
	if playerInputComponent.get_dash_input():
		linearVelocityComponent.apply_velocity(playerInputComponent.get_movement_input(), 4000)
