extends Node2D
class_name FlipperComponent

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

var _input_history: Array[Vector2] = []
const BUFFER_SIZE: int = 6

func _physics_process(delta: float) -> void:
	flipper_charge(delta)

func flipper_charge(delta: float) -> void:
	if not can_use_flipper or not inputControllerComponent:
		return
		
	var input_direction = inputControllerComponent.movement_vector
	
	if input_direction != Vector2.ZERO:
		_input_history.append(input_direction)
		if _input_history.size() > BUFFER_SIZE:
			_input_history.remove_at(0)
			
		hit_direction = input_direction.normalized()
		
		if hit_force == 0.0:
			hit_force = hit_min_charge
		else:
			hit_force = min(hit_force + (hit_charge_speed * delta), hit_max_charge)
	else:
		if hit_force > 0.0:
			hit_direction = _get_best_direction_from_buffer()
			flipper_hit()

func _get_best_direction_from_buffer() -> Vector2:
	if _input_history.is_empty():
		return hit_direction
		
	var best_dir: Vector2 = hit_direction
	var max_diagonal_score: float = -1.0
	
	for dir in _input_history:
		var score: float = abs(dir.x) * abs(dir.y)
		if score > max_diagonal_score:
			max_diagonal_score = score
			best_dir = dir.normalized()
			
	_input_history.clear()
	return best_dir

func flipper_hit() -> void:
	if customImpulsePhysic:
		customImpulsePhysic.apply_dynamic_impulse(hit_direction, hit_force, int(dynamic_force_percent))
	
	hit_force = 0.0
	can_use_flipper = false
	
	await get_tree().create_timer(hit_cooldown).timeout
	can_use_flipper = true
