@tool
extends Area2D
class_name BaseWaveSpawner

@export_group("Configurações do Spawner")
@export var enabled : bool = true
@export var loop_after_all_waves : bool = false

@export_group("Configurações de Inimigos e Ondas")
@export var waves: Array[WaveData] = []

@export_group("Área de Spawn")
@export var collision_shape: CollisionShape2D
@export var zone_size: Vector2 = Vector2(100, 100):
	set(value):
		zone_size = value
		if collision_shape and collision_shape.shape:
			collision_shape.shape = collision_shape.shape.duplicate()
			collision_shape.shape.size = value

var current_wave_index: int = 0
var spawned_enemies: Array = []

func _ready() -> void:
	if Engine.is_editor_hint() or !enabled:
		return
	start_wave(current_wave_index)

func set_spawner_enabled(p_enabled: bool) -> void:
	if enabled == p_enabled:
		return
	else:
		enabled = p_enabled
	
	if enabled:
		start_wave(current_wave_index)

func start_wave(wave_number: int) -> void:
	if !enabled:
		return
	current_wave_index = wave_number
	
	if current_wave_index >= waves.size():
		if loop_after_all_waves:
			current_wave_index = 0
		else:
			enabled = false
			return
	
	get_tree().create_timer(waves[current_wave_index].wave_time, true, false, true).timeout.connect(start_wave.bind(current_wave_index+1))
	print ("new wave")
	print(current_wave_index)
	print ("Tempo de jogo: ", Time.get_ticks_msec() / 1000.0, " segundos")
	start_wave_group(current_wave_index)

func start_wave_group(wave_number: int) -> void:
	if wave_number != current_wave_index or !enabled:
		return
	get_tree().create_timer(waves[wave_number].spawn_interval_groups, true, false, true).timeout.connect(start_wave_group.bind(wave_number))
	var wave : WaveData = waves[wave_number]
	
	var camera = get_viewport().get_camera_2d()
	if not camera:
		return
	
	var spawn_queue: Array[PackedScene] = []
	for config in wave.enemies_to_spawn:
		if config and config.enemy_type and config.quantity > 0:
			var current_count_of_this_type = 0
			for enemy in spawned_enemies:
				if is_instance_valid(enemy) and enemy.scene_file_path == config.enemy_type.resource_path:
					current_count_of_this_type += 1
			var needed = config.quantity - current_count_of_this_type
			for i in range(needed):
				spawn_queue.append(config.enemy_type)
	if spawn_queue.is_empty():
		return
	start_enemy_spawn(wave_number, camera, spawn_queue, 0)

func start_enemy_spawn(wave_number : int, camera: Camera2D, spawn_queue: Array[PackedScene], queue_pos: int):
	if wave_number != current_wave_index or queue_pos >= spawn_queue.size() or !enabled:
		return
	get_tree().create_timer(waves[wave_number].spawn_interval_enemies, true, false, true).timeout.connect(start_enemy_spawn.bind(wave_number, camera, spawn_queue, (queue_pos+1)))
	
	var spawn_pos = calculate_spawn_position(camera)
	if spawn_pos != Vector2.ZERO:
		spawn_enemy_at(spawn_queue[queue_pos], spawn_pos)
	queue_pos += 1

func calculate_spawn_position(camera: Camera2D) -> Vector2:
	var camera_center = camera.get_screen_center_position()
	var viewport_rect = get_viewport_rect()
	var viewport_size = viewport_rect.size / camera.zoom
	
	var min_cam_y = camera_center.y - (viewport_size.y / 2.0)
	var max_cam_y = camera_center.y + (viewport_size.y / 2.0)
	
	var min_zone_y = global_position.y - (zone_size.y / 2.0)
	var max_zone_y = global_position.y + (zone_size.y / 2.0)
	
	var start_y = max(min_cam_y, min_zone_y)
	var end_y = min(max_cam_y, max_zone_y)
	
	if start_y >= end_y:
		start_y = min_zone_y
		end_y = max_zone_y
		
	var min_zone_x = global_position.x - (zone_size.x / 2.0)
	var max_zone_x = global_position.x + (zone_size.x / 2.0)
	var spawn_x = randf_range(min_zone_x, max_zone_x)
	var spawn_y = randf_range(start_y, end_y)
	
	return Vector2(spawn_x, spawn_y)

func spawn_enemy_at(enemy_scene: PackedScene, pos: Vector2) -> void:
	if not enemy_scene:
		return
	
	var enemy = enemy_scene.instantiate()
	enemy.global_position = pos
	
	get_parent().add_child.call_deferred(enemy)
	spawned_enemies.append(enemy)
	
	var health_comp = enemy.get_node_or_null("HealthComponent")
	if health_comp and health_comp.has_signal("died"):
		health_comp.died.connect(enemy_erase.bind(enemy))

func enemy_erase(enemy: Node) -> void:
	spawned_enemies.erase(enemy)
