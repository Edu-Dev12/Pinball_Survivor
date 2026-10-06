@tool
extends Area2D
class_name BaseWaveSpawner

@export var enabled = true
@export_group("Configurações de Inimigo")
@export var enemy_to_spawn: PackedScene
@export var max_qty_to_spawn: int = 10

@export_group("Tempos do Spawner")
@export var wave_cooldown: float = 5.0 ## Tempo de espera entre cada onda
@export var spawn_interval: float = 0.5 ## Tempo entre a geração de cada inimigo individual

@export_group("Área de Spawn")
@export var collision_shape: CollisionShape2D
@export var zone_size: Vector2 = Vector2(100, 100):
	set(value):
		zone_size = value
		if collision_shape and collision_shape.shape:
			collision_shape.shape = collision_shape.shape.duplicate()
			collision_shape.shape.size = value

var spawned_enemies: Array = []
var is_spawning: bool = false
var spawn_timer: Timer

func _ready() -> void:
	if Engine.is_editor_hint() or !enabled:
		return
		
	spawn_timer = Timer.new()
	spawn_timer.wait_time = wave_cooldown
	spawn_timer.one_shot = false
	spawn_timer.autostart = true
	add_child(spawn_timer)
	spawn_timer.timeout.connect(verify_spawn)

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	spawned_enemies = spawned_enemies.filter(func(enemy): return is_instance_valid(enemy))

func verify_spawn() -> void:
	if is_spawning or spawned_enemies.size() >= max_qty_to_spawn:
		return
		
	var camera = get_viewport().get_camera_2d()
	if not camera:
		return
		
	is_spawning = true
	var enemies_needed = max_qty_to_spawn - spawned_enemies.size()
	
	for i in range(enemies_needed):
		var spawn_pos = calculate_spawn_position(camera)
		if spawn_pos != Vector2.ZERO:
			spawn_enemy_at(spawn_pos)
			await get_tree().create_timer(spawn_interval).timeout
		else:
			break
	is_spawning = false

func calculate_spawn_position(camera: Camera2D) -> Vector2:
	var camera_center = camera.get_screen_center_position()
	var viewport_size = get_viewport_rect().size / camera.zoom
	
	# Limites verticais da câmera (altura atual da tela no mundo)
	var min_cam_y = camera_center.y - (viewport_size.y / 2.0)
	var max_cam_y = camera_center.y + (viewport_size.y / 2.0)

	# Limites verticais desta Area2D retangular
	var min_zone_y = global_position.y - (zone_size.y / 2.0)
	var max_zone_y = global_position.y + (zone_size.y / 2.0)

	# Intersecção entre a altura da câmera e a altura da área
	var start_y = max(min_cam_y, min_zone_y)
	var end_y = min(max_cam_y, max_zone_y)

	# Se a área não estiver visível na altura da câmera
	if start_y >= end_y:
		return Vector2.ZERO

	# Posição X aleatória dentro da largura da área de spawn
	var min_zone_x = global_position.x - (zone_size.x / 2.0)
	var max_zone_x = global_position.x + (zone_size.x / 2.0)
	var spawn_x = randf_range(min_zone_x, max_zone_x)

	# Posição Y aleatória limitada à altura visível da câmera
	var spawn_y = randf_range(start_y, end_y)

	return Vector2(spawn_x, spawn_y)

func spawn_enemy_at(pos: Vector2) -> void:
	if not enemy_to_spawn:
		return

	var enemy = enemy_to_spawn.instantiate()
	enemy.global_position = pos

	get_parent().add_child(enemy)
	spawned_enemies.append(enemy)
