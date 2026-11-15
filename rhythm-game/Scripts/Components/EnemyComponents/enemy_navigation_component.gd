extends NavigationAgent2D
class_name EnemyNavigationComponent

signal orbit_reached

enum TARGET_TYPE {
	STRUCTURE,
	PLAYER
}

@export_group("Configurações de Componentes")
@export var enemy: CharacterBody2D
@export var knockback_component: KnockbackComponent

@export_group("Configurações de Valores")
@export var target_type: TARGET_TYPE = TARGET_TYPE.STRUCTURE
@export var speed: float = 100.0
@export var orbit_radius: float = 30.0
@export var attack_off_set: float = 15.0

var target: Node2D
var target_offset_position: Vector2
var _has_emitted_orbit: bool = false
var is_active: bool = true

func _ready() -> void:
	velocity_computed.connect(_on_velocity_computed)

func update_movement(_delta: float) -> void:
	if not is_active or not enemy or not target or not is_instance_valid(target):
		return
		
	if knockback_component and knockback_component.is_knockbacked():
		return
		
	if is_navigation_finished():
		enemy.velocity = Vector2.ZERO
		enemy.move_and_slide()
		return
		
	var current_agent_position = enemy.global_position
	var next_path_position = get_next_path_position()
	var direction = (next_path_position - current_agent_position).normalized()
	var desired_velocity = direction * speed
	
	if avoidance_enabled:
		set_velocity(desired_velocity)
	else:
		enemy.velocity = desired_velocity
		enemy.move_and_slide()
	
	if not _has_emitted_orbit:
		if enemy.global_position.distance_to(target.global_position) <= orbit_radius + attack_off_set:
			_has_emitted_orbit = true
			orbit_reached.emit()

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	if not is_active:
		return
	if enemy:
		enemy.velocity = safe_velocity
		enemy.move_and_slide()

func find_target() -> void:
	if target_type == TARGET_TYPE.STRUCTURE:
		find_structure()
	elif target_type == TARGET_TYPE.PLAYER:
		find_player()

func find_structure() -> void:
	var structure_list = get_tree().get_nodes_in_group(Global.STRUCTURE_GROUP)
	
	if structure_list.size() > 0:
		var target_to_remove: Node2D = structure_list[0]
		for target_check in structure_list:
			if target_to_remove.global_position.distance_to(enemy.global_position) > target_check.global_position.distance_to(enemy.global_position):
				target_to_remove = target_check
		structure_list.erase(target_to_remove)
		
		if structure_list.size() > 0:
			target = structure_list.pick_random() as Node2D
		else:
			target = target_to_remove
		
		var random_angle = randf() * TAU
		var offset_dir = Vector2(cos(random_angle), sin(random_angle))
		target_offset_position = target.global_position + (offset_dir * orbit_radius)
		
		target_position = target_offset_position

func find_player() -> void:
	pass

func stop() -> void:
	is_active = false
	if enemy:
		enemy.velocity = Vector2.ZERO
