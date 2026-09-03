extends CharacterBody2D
class_name Player
@onready var color_rect: ColorRect = $ColorRect

@export_subgroup("Movement")
@export var linearVelocityComponent: LinearVelocityComponent

@export_subgroup("Controller")
@export var playerInputComponent: PlayerInputComponent
@export var bpm_controller_component: BPMControllerComponent

func _physics_process(delta: float) -> void:
	#if !playerInputComponent.is_dashing:
		#if playerInputComponent.is_receiving_movement_input() and bpm_controller_component.on_beat:
			#linearVelocityComponent.apply_velocity(playerInputComponent.get_movement_input(), 200)
		#else:
			#linearVelocityComponent.stop_movement()
		#
	#if playerInputComponent.get_dash_input() and bpm_controller_component.on_beat:
		#linearVelocityComponent.apply_velocity(playerInputComponent.get_movement_input(), 4000)
		
	if bpm_controller_component.on_beat:
		if playerInputComponent.get_dash_input():
			color_rect.color = "ff5b00"
		
	else:
		color_rect.color = "ffffff"
