extends Node2D
class_name FlipperHitComponent

@export var hit_max_charge: float = 1200.0
@export var hit_min_charge: float = 200.0
@export var hit_charge_speed: float = 800.0
@export_range(0, 100, 1, "slider") var dynamic_force_percent: float = 0
@export var hit_cooldown: float = 0.5

@export_group("Components")
@export var inputControllerComponent: InputControllerComponent
@export var customImpulsePhysic: CustomImpulsePhysicComponent

var can_use_flipper: bool = true
var hit_force: float = 0.0
var hit_direction: Vector2 = Vector2.UP

func flipper_charge(delta: float) -> void:
	if not can_use_flipper or not inputControllerComponent:
		return
		
	var input_direction = inputControllerComponent.movement_vector
	
	if input_direction != Vector2.ZERO:
		hit_direction = input_direction.normalized()
		
		if hit_force == 0.0:
			hit_force = hit_min_charge
		else:
			hit_force = min(hit_force + (hit_charge_speed * delta), hit_max_charge)
	else:
		if hit_force > 0.0:
			hit_direction = inputControllerComponent.get_best_buffered_direction(hit_direction)
			flipper_hit()

func flipper_hit() -> void:
	if customImpulsePhysic:
		customImpulsePhysic.apply_dynamic_impulse(hit_direction, hit_force, int(dynamic_force_percent))
	
	hit_force = 0.0
	can_use_flipper = false
	
	await get_tree().create_timer(hit_cooldown).timeout
	can_use_flipper = true
