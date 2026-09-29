extends Node2D
class_name CustomImpulsePhysicComponent

@export var rigidBody2D: RigidBody2D

func apply_basic_impulse(direction: Vector2, force: float, percent_velocity_reset: int = 0):
	rigidBody2D.linear_velocity *= (100 - percent_velocity_reset) / 100.0
	
	rigidBody2D.apply_central_impulse(direction * force)
	
	print("BASIC: Applied Force: " + str(direction * force))
	
	
func apply_dynamic_impulse(direction: Vector2, force: float, percent_inpulse_compensation: int = 0) -> void:
	if not rigidBody2D:
		return
	
	var dir_norm: Vector2 = direction.normalized()
	var current_velocity_in_dir: float = rigidBody2D.linear_velocity.dot(dir_norm)
	
	var compensation_impulse: float = 0.0
	if current_velocity_in_dir < 0.0:
		compensation_impulse = abs(current_velocity_in_dir) * rigidBody2D.mass * (percent_inpulse_compensation / 100.0)
	
	var final_impulse: Vector2 = dir_norm * (force + compensation_impulse)
	rigidBody2D.apply_central_impulse(final_impulse)
	
	print("DYNAMIC: Applied Force: " + str(final_impulse))
