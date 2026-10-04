extends Camera2D

var can_follow_player: bool = false
var current_player_node: PlayerBody

func _ready() -> void:
	SignalManager.level_loaded.connect(update_camera_limits)
	SignalManager.disable_camera_follow.connect(turn_off_follow)
	if current_player_node:
		can_follow_player = true

func _physics_process(_delta: float) -> void:
	if current_player_node and can_follow_player:
		global_position = current_player_node.rigidBody2D.global_position

func update_camera_limits(new_tilemap: TileMapLayer) -> void:
	var map_rect: Rect2 = new_tilemap.get_used_rect()
	var tile_size: Vector2 = new_tilemap.tile_set.tile_size
	# Pega a escala real aplicada ao nó (ex: Vector2(2, 2))
	var tile_scale: Vector2 = new_tilemap.scale
	var global_pos: Vector2 = new_tilemap.global_position

	# Multiplica o tamanho do tile pela escala real do nó
	var real_tile_size: Vector2 = tile_size * tile_scale

	limit_left = int(map_rect.position.x * real_tile_size.x + global_pos.x)
	limit_top = int(map_rect.position.y * real_tile_size.y + global_pos.y)
	limit_right = int(map_rect.end.x * real_tile_size.x + global_pos.x)
	limit_bottom = int(map_rect.end.y * real_tile_size.y + global_pos.y)
	

func update_player_node(new_player):
	current_player_node = new_player
	can_follow_player = true

func increase_camera_limit_right(amount: float):
	limit_right += int(amount)

func turn_off_follow():
	can_follow_player = false
