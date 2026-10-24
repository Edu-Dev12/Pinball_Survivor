extends Node
class_name FlipperHitComponent

@export_custom(ETP.NONE, ETP.PROPERTY) var hit_max_charge: float = 1200.0
@export_custom(ETP.NONE, ETP.PROPERTY) var hit_min_charge: float = 200.0
@export_custom(ETP.NONE, ETP.PROPERTY) var hit_charge_speed: float = 800.0
@export_range(0, 100, 1, "slider", ETP.PROPERTY) var dynamic_force_percent: float = 0
@export var velocity_override_curve: Curve
@export var slow_motion_curve: Curve

@export_group("Components")
@export var customImpulsePhysic: CustomImpulsePhysicComponent

var can_use_flipper: bool = true
var hit_force: float = 0.0
var hit_direction: Vector2 = Vector2.UP

func flipper_charge(charge_direction: Vector2) -> void:
	if charge_direction != Vector2.ZERO:
		hit_direction = charge_direction.normalized()
		
		var real_delta: float = get_process_delta_time()
		
		if hit_force == 0.0:
			hit_force = hit_min_charge
		else:
			hit_force = min(hit_force + (hit_charge_speed * real_delta), hit_max_charge)


func flipper_hit(buffer_hit_direction: Vector2 = Vector2.ZERO) -> void:
	if customImpulsePhysic:
		var calculated_override: float = remap(hit_force, hit_min_charge, hit_max_charge, 0, 1)
		calculated_override = velocity_override_curve.sample(calculated_override) * 100
		customImpulsePhysic.apply_dynamic_impulse(buffer_hit_direction, hit_force, int(dynamic_force_percent), int(calculated_override))
	
	hit_force = 0.0
