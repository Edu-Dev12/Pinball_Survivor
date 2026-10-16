extends NavigationAgent2D
class_name EnemyNavigationComponent

signal orbit_reached

@export var enemy: CharacterBody2D
@export var speed: float = 100.0
@export var orbit_radius: float = 30.0
@export var attack_off_set: float = 15.0

var target: Node2D
var target_offset_position: Vector2
var _has_emitted_orbit: bool = false

func _ready() -> void:
	velocity_computed.connect(_on_velocity_computed)
	call_deferred("find_structure")

func _physics_process(_delta: float) -> void:
	if not enemy or not target or not is_instance_valid(target):
		return
		
	if is_navigation_finished():
		enemy.velocity = Vector2.ZERO
		enemy.move_and_slide()
		return
		
	if not _has_emitted_orbit:
		if enemy.global_position.distance_to(target.global_position) <= orbit_radius + attack_off_set:
			_has_emitted_orbit = true
			orbit_reached.emit()
		
	var current_agent_position = enemy.global_position
	var next_path_position = get_next_path_position()
	var direction = (next_path_position - current_agent_position).normalized()
	var desired_velocity = direction * speed
	
	if avoidance_enabled:
		set_velocity(desired_velocity)
	else:
		enemy.velocity = desired_velocity
		enemy.move_and_slide()

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	if enemy:
		enemy.velocity = safe_velocity
		enemy.move_and_slide()

func find_structure() -> void:
	var structure_list = get_tree().get_nodes_in_group(Global.STRUCTURE_GROUP)
	
	if structure_list.size() > 0:
		target = structure_list.pick_random() as Node2D
		
		var random_angle = randf() * TAU
		var offset_dir = Vector2(cos(random_angle), sin(random_angle))
		target_offset_position = target.global_position + (offset_dir * orbit_radius)
		
		target_position = target_offset_position
