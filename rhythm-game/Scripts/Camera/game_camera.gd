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
		self.position = current_player_node.position

func update_camera_limits(new_tilemap: TileMapLayer) -> void:
	var map_rect: Rect2 = new_tilemap.get_used_rect()
	var tile_size: Vector2 = new_tilemap.tile_set.tile_size
	var global_pos: Vector2 = new_tilemap.global_position

	# Canto superior esquerdo em pixels
	limit_left = int(map_rect.position.x * tile_size.x + global_pos.x)
	limit_top = int(map_rect.position.y * tile_size.y + global_pos.y)
	
	# Canto inferior direito em pixels
	limit_right = int(map_rect.end.x * tile_size.x + global_pos.x)
	limit_bottom = int(map_rect.end.y * tile_size.y + global_pos.y)
	

func update_player_node(new_player):
	current_player_node = new_player
	can_follow_player = true

func increase_camera_limit_right(amount: float):
	limit_right += int(amount)

func turn_off_follow():
	can_follow_player = false
