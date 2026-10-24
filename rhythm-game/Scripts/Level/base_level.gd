extends Node2D
class_name BaseLevel

@export_group("Level Manager")
@export_enum("menu", "run_over_level", "level_1") var next_level: String

@export_group("Level Traits")
@export var level_map: LevelMap
@export var level_initial_time_seconds: int = 120
@export var player: PlayerBody
@export var enemies: Node2D 

var tile_map_layer: TileMapLayer
var camera_reference: Camera2D

func _ready() -> void:
	SignalManager.respond_camera_reference.connect(update_camera_reference)
	
	if level_map and level_map.tile_map:
		tile_map_layer = level_map.tile_map
		SignalManager.level_loaded.emit(tile_map_layer)
	
	if player:
		SignalManager.player_spawned.emit(player)
		
	SignalManager.request_camera_reference.emit()
	
	Ui.set_initial_time(level_initial_time_seconds)

func update_camera_reference(new_camera_reference: Camera2D) -> void:
	camera_reference = new_camera_reference

func despawn_level() -> void:
	if is_instance_valid(enemies):
		enemies.queue_free()

func next_level_reached():
	SignalManager.next_level_reached.emit(next_level)
