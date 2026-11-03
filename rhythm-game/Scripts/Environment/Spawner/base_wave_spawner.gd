@tool
extends Area2D
class_name BaseWaveSpawner

signal wave_started(wave_index: int)
signal wave_completed(wave_index: int)
signal all_waves_finished

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
var is_running: bool = false
var spawned_enemies: Array = []
var wave_processing_active: bool = false

func _ready() -> void:
	if Engine.is_editor_hint() or !enabled:
		return
	process_mode = Node.PROCESS_MODE_ALWAYS
	start_spawner_loop()

func set_spawner_enabled(p_enabled: bool) -> void:
	enabled = p_enabled
	
	if enabled and not is_running:
		start_spawner_loop()
	elif not enabled:
		is_running = false
		wave_processing_active = false

func start_spawner_loop() -> void:
	if is_running or waves.is_empty():
		return
	is_running = true
	current_wave_index = 0
	
	while is_running and current_wave_index < waves.size():
		var current_wave = waves[current_wave_index]
		if not current_wave:
			current_wave_index += 1
			continue
		
		wave_processing_active = true
		emit_signal("wave_started", current_wave_index)
		print ("new wave")
		print(current_wave_index)
		await process_wave(current_wave)
		
		if not is_running:
			break
		emit_signal("wave_completed", current_wave_index)
		
		if current_wave.time_to_next_wave > 0:
			await get_tree().create_timer(current_wave.time_to_next_wave).timeout
			if not is_running:
				break
		current_wave_index += 1
		
		if current_wave_index >= waves.size():
			emit_signal("all_waves_finished")
			if loop_after_all_waves:
				current_wave_index = 0
			else:
				break
	is_running = false
	wave_processing_active = false

func process_wave(wave: WaveData) -> void:
	var wave_timer = 0.0
	var group_clock = 0.0
	
	await get_tree().process_frame
	if not is_running:
		return
	spawn_wave_batch(wave)
	
	while is_running:
		var delta = get_process_delta_time()
		wave_timer += delta
		group_clock += delta
		var time_expired = wave_timer >= wave.wave_time
		spawned_enemies = spawned_enemies.filter(func(e): return is_instance_valid(e))
		
		if not time_expired:
			if group_clock >= wave.spawn_interval_groups:
				group_clock = 0.0
				spawn_wave_batch(wave)
		else:
			if not wave.all_enemies_must_be_dead_to_finish or spawned_enemies.is_empty():
				break
		await get_tree().process_frame

func spawn_wave_batch(wave: WaveData) -> void:
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
		
	for enemy_scene in spawn_queue:
		if not is_running:
			break
		var spawn_pos = calculate_spawn_position(camera)
		if spawn_pos != Vector2.ZERO:
			spawn_enemy_at(enemy_scene, spawn_pos)
			if wave.spawn_interval_enemies > 0.0:
				await get_tree().create_timer(wave.spawn_interval_enemies, true, false, true).timeout

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
	
	get_parent().add_child(enemy)
	spawned_enemies.append(enemy)
	
	var health_comp = enemy.get_node_or_null("HealthComponent")
	if health_comp and health_comp.has_signal("died"):
		health_comp.died.connect(enemy_erase.bind(enemy))

func enemy_erase(enemy: Node) -> void:
	spawned_enemies.erase(enemy)
