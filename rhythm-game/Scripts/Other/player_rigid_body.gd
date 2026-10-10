extends RigidBody2D

@export var player: PlayerBody

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if state.linear_velocity.length() > player.max_speed:
		state.linear_velocity = state.linear_velocity.limit_length(player.max_speed)
