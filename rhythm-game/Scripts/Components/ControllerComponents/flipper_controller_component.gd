extends Node2D
class_name FlipperControllerComponent

@export var hit_cooldown: float = 0.5 

@export_group("Components")
@export var inputControllerComponent: InputControllerComponent
@export var flipperHitComponent: FlipperHitComponent
@export var flipper: Flipper

var flipper_charging: bool = false
var can_use_flipper: bool = true

func _physics_process(delta: float) -> void:
	if not inputControllerComponent:
		return
		
	var input_direction = inputControllerComponent.movement_vector
	
	if input_direction != Vector2.ZERO and can_use_flipper:
		flipper_charging = true
		flipperHitComponent.flipper_charge(delta, input_direction)
		
		if flipper:
			flipper.rotation = input_direction.angle() + deg_to_rad(90.0)
			flipper.animate_charge(flipperHitComponent.hit_force, flipperHitComponent.hit_min_charge, flipperHitComponent.hit_max_charge)
			
	elif flipper_charging and can_use_flipper:
		flipper_charging = false
		can_use_flipper = false
		
		var buffered_dir = inputControllerComponent.get_best_buffered_direction(input_direction)
		
		if flipper:
			await flipper.animate_release()
			
		flipperHitComponent.flipper_hit(buffered_dir)
		start_cooldown()

func start_cooldown() -> void:
	can_use_flipper = false
	await get_tree().create_timer(hit_cooldown).timeout
	can_use_flipper = true
