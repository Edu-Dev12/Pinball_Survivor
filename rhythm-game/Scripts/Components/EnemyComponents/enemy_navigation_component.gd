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
@export var max_enemy_speed: float = 250.0
@export var min_enemy_speed: float = 150.0
@export var orbit_radius: float = 30.0
@export var attack_off_set: float = 15.0

var speed: float
var is_active: bool = true
var is_chasing_player = false
var has_emitted_orbit: bool = false
var target: Node2D

func _ready() -> void:
	velocity_computed.connect(_on_velocity_computed)
	define_speed() 

func update_movement(_delta: float) -> void:
	if not is_active or not enemy or not target or not is_instance_valid(target):
		return
		
	if knockback_component and knockback_component.is_knockbacked():
		return
	
	if is_chasing_player:
		find_player()
		
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
	
	if not has_emitted_orbit:
		if enemy.global_position.distance_to(target.global_position) <= orbit_radius + attack_off_set:
			has_emitted_orbit = true
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
		if not is_chasing_player:
			is_chasing_player = true
			target = get_tree().get_first_node_in_group(Global.PLAYER_BODY_GROUP)
			get_tree().create_timer(1, true, false, true).timeout.connect(find_player)

func find_structure() -> void:
	var structure_list = get_tree().get_nodes_in_group(Global.STRUCTURE_GROUP)
	var target_offset_position: Vector2
	
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
	if not is_active or not target or not is_instance_valid(target):
		is_chasing_player  = false
		return
	target_position = target.global_position
	get_tree().create_timer(1, true, false, true).timeout.connect(find_player)

func define_speed() -> void:
	speed = randf_range(min_enemy_speed, max_enemy_speed)

func stop() -> void:
	is_active = false
	if enemy:
		enemy.velocity = Vector2.ZERO
