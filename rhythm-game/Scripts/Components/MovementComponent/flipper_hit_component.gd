extends Node2D
class_name FlipperHitComponent

@export_custom(ETP.NONE, ETP.PROPERTY) var hit_max_charge: float = 1200.0
@export_custom(ETP.NONE, ETP.PROPERTY) var hit_min_charge: float = 200.0
@export_custom(ETP.NONE, ETP.PROPERTY) var hit_charge_speed: float = 800.0
@export_range(0, 100, 1, "slider", ETP.PROPERTY) var dynamic_force_percent: float = 0


@export_group("Components")
@export var customImpulsePhysic: CustomImpulsePhysicComponent

var can_use_flipper: bool = true
var hit_force: float = 0.0
var hit_direction: Vector2 = Vector2.UP

func flipper_charge(delta: float, charge_direction: Vector2) -> void:
	if charge_direction != Vector2.ZERO:
		hit_direction = charge_direction.normalized()
		
		if hit_force == 0.0:
			hit_force = hit_min_charge
		else:
			hit_force = min(hit_force + (hit_charge_speed * delta), hit_max_charge)


func flipper_hit(buffer_hit_direction: Vector2 = Vector2.ZERO) -> void:
	if customImpulsePhysic:
		customImpulsePhysic.apply_dynamic_impulse(buffer_hit_direction, hit_force, int(dynamic_force_percent))
	
	hit_force = 0.0
