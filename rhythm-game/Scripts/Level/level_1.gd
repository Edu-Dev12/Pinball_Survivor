extends BaseLevel
class_name Level1

@export_group("Level Traits")
@export var boss_spawn_pointer : Marker2D
@export var boss_to_spawn : PackedScene

func _ready() -> void:
	AudioManager.change_current_music(Global.BGM_SPACE_CADET_PINBALL)
	SignalManager.level_timer_ended.connect(start_boss_fight)
	SignalManager.level_won.connect(next_level_reached)
	super()

func start_boss_fight() -> void:
	for spawner : BaseWaveSpawner in get_tree().get_nodes_in_group(Global.SPAWNER_GROUP):
		spawner.enabled = false
	boss_spawn()

func boss_spawn() -> void:
	if not boss_to_spawn:
		return
	var boss = boss_to_spawn.instantiate()
	boss.global_position = boss_spawn_pointer.global_position
	enemies.add_child(boss)
