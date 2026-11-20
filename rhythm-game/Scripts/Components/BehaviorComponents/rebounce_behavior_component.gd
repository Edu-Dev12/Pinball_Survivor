extends Node
class_name RebounceBehaviorComponent

@export var hurt_box_component: HurtboxComponent

@export_group("KNOCKBACK")
@export var knockback_standard_force: float = 0.0
@export var knockback_decay_rate: float = 1000.0

@export_group("BOUNCE")
@export var bounce_force: float = 0.0
@export_range(0.0, 100.0, 1.0, "suffix:%") var bounce_damping: float = 0.0

var source: Node2D
var knockback_velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	if hurt_box_component:
		hurt_box_component.was_hurt.connect(_on_was_hurt)
		find_source()
		
func _physics_process(delta: float) -> void:
	if not is_knockbacked() or not source is CharacterBody2D:
		return
	source.velocity = knockback_velocity
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, delta * knockback_decay_rate)
	source.move_and_slide()
	
func _on_was_hurt(hitbox: HitboxComponent) -> void:
	apply_bounce_and_knockback(hitbox.get_parent())
	
func find_source() -> void:
	source = hurt_box_component.get_parent()
	
func apply_bounce_and_knockback(target: Node2D) -> void:
	apply_bounce(target)
	apply_knockback(target, knockback_standard_force)

func check_rigid_body(target: Node2D) -> Node2D:
	if target is PlayerBody:
		return get_tree().get_first_node_in_group(Global.PLAYER_BODY_GROUP) as RigidBody2D
	return target

#-----------------------------------
# BOUNCE
#-----------------------------------
func apply_bounce(target: Node2D) -> void:
	target = check_rigid_body(target)
	if target is RigidBody2D:
		rigidbody_bounce(target)

func rigidbody_bounce(rigidbody: RigidBody2D) -> void:
	var current_speed: float = rigidbody.linear_velocity.length()
	var damping_multiplier: float = 1.0 - (bounce_damping / 100.0)
	var damped_speed: float = current_speed * damping_multiplier
	
	var escape_direction: Vector2 = (rigidbody.global_position - source.global_position).normalized()
	var final_speed: float = damped_speed + bounce_force
	rigidbody.linear_velocity = escape_direction * final_speed

#-----------------------------------
# KNOCKBACK
#-----------------------------------
func is_knockbacked() -> bool:
	return not knockback_velocity.is_zero_approx()
	
func apply_knockback(target: Node2D, knockback_force: float) -> void:
	if knockback_force <= 0.0 or not source:
		return
	target = check_rigid_body(target)
	var knockback_direction: Vector2 = (source.global_position - target.global_position).normalized()
	knockback_velocity = knockback_direction * knockback_force
