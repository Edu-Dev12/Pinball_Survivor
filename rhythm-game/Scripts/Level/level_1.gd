extends BaseLevel
class_name Level1

@export_group("Level Traits")
@export var boss_spawn_pointer : Marker2D

func _ready() -> void:
	AudioManager.change_current_music(Global.BGM_SPACE_CADET_PINBALL)
	super()

func start_boss_fight() -> void:
	for spawner : BaseWaveSpawner in get_tree().get_nodes_in_group(Global.SPAWNER_GROUP):
		spawner.enabled = false
	# enemies.add_child()
