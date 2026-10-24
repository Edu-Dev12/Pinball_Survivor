extends Node
class_name CustomImpulsePhysicComponent

@export var rigidBody2D: RigidBody2D

func apply_basic_impulse(direction: Vector2, force: float, percent_velocity_reset: int = 0) -> void:
	if not rigidBody2D: return
	rigidBody2D.linear_velocity *= (100 - percent_velocity_reset) / 100.0
	rigidBody2D.apply_central_impulse(direction * force)

func apply_dynamic_impulse(direction: Vector2, force: float, percent_inpulse_compensation: int = 0, percent_velocity_override: int = 0) -> void:
	if not rigidBody2D: return
	
	# Obtém o vetor final calculado e aplica diretamente na velocidade do corpo
	rigidBody2D.linear_velocity = get_predicted_velocity(direction, force, percent_inpulse_compensation, percent_velocity_override)

func get_predicted_velocity(direction: Vector2, force: float, percent_inpulse_compensation: int = 0, percent_velocity_override: int = 0) -> Vector2:
	if not rigidBody2D: 
		return Vector2.ZERO
	
	var dir_norm: Vector2 = direction.normalized()
	var simulated_velocity: Vector2 = rigidBody2D.linear_velocity
	
	if percent_velocity_override > 0:
		var current_speed: float = simulated_velocity.length()
		var redirected_velocity: Vector2 = dir_norm * current_speed
		var factor: float = percent_velocity_override / 100.0
		simulated_velocity = simulated_velocity.lerp(redirected_velocity * factor, factor)

	var current_velocity_in_dir: float = simulated_velocity.dot(dir_norm)
	var compensation_impulse: float = 0.0
	if current_velocity_in_dir < 0.0:
		compensation_impulse = abs(current_velocity_in_dir) * rigidBody2D.mass * (percent_inpulse_compensation / 100.0)
	
	var final_impulse: Vector2 = dir_norm * (force + compensation_impulse)
	var velocity_change: Vector2 = final_impulse / rigidBody2D.mass
	
	return simulated_velocity + velocity_change
