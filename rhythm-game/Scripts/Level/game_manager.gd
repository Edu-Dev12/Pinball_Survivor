extends Node
class_name GameManager

@export_enum("menu","game_over","level_1") var starting_level_name: String = "level_1"
@export_enum("menu","game_over","level_1") var try_again_scene_name: String = "game_over"
@onready var camera: Camera2D = $GameCamera

# Leveis de sistema e fluxo
const MENU = preload("res://Scenes/Level/menu.tscn")
const GAME_OVER = preload("res://Scenes/Level/game_over.tscn")
# Leveis de jogo
const LEVEL_1_1 = preload("res://Scenes/Level/level_1.tscn")

var current_level_node: Node2D
var current_level_packed_scene: PackedScene
var game_leveis = {
	# Telas de sistema e fluxo
	"menu": MENU,
	"game_over": GAME_OVER,
	# Fases do jogo
	"level_1": LEVEL_1_1
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.next_level_reached.connect(change_current_level)
	SignalManager.level_loaded.connect(update_tilemap)
	SignalManager.game_over.connect(game_over)
	
	SignalManager.player_spawned.connect(update_player)
	SignalManager.player_died.connect(player_died)
	
	SignalManager.request_camera_reference.connect(send_camera_reference)
	
	change_current_level(starting_level_name)
	
func update_player(new_player: PlayerBody):
	camera.update_player_node(new_player)

func update_tilemap(new_tilemap: TileMapLayer):
	camera.update_camera_limits(new_tilemap)

func change_current_level(level_name: String):
	# Verifica se a chave existe no dicionário para evitar crashes
	if not game_leveis.has(level_name):
		print("Erro: A cena '" + level_name + "' não existe no dicionário game_leveis!")
		return
		
	if current_level_node:
		current_level_node.queue_free()
		
	var target_scene = game_leveis[level_name]
	current_level_packed_scene = target_scene
	
	var new_current_level = target_scene.instantiate()
	add_child(new_current_level)
	camera.can_follow_player = true
	current_level_node = new_current_level

func player_died():
	if current_level_node:
		current_level_node.queue_free()
	current_level_node = current_level_packed_scene.instantiate()
	add_child(current_level_node)
	AudioManager.play_current_music()

func game_over():
	if current_level_node:
		current_level_node.queue_free()
	camera.free_limits()
	camera.position = Vector2(128,120)
	
	if game_leveis.has(try_again_scene_name):
		var try_again_scene = game_leveis[try_again_scene_name]
		var new_current_level = try_again_scene.instantiate()
		add_child(new_current_level)
		current_level_node = new_current_level
	else:
		print("Erro: Tela de game_over não configurada corretamente!")

func send_camera_reference():
	SignalManager.respond_camera_reference.emit(camera)
