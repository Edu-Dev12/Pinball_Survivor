extends BaseLevel
class_name Level1

@export_group("Level Traits")
@export var boss_spawn_pointer : Marker2D
@export var boss_to_spawn : PackedScene

func _ready() -> void:
	AudioManager.change_current_music(Global.BGM_SPACE_CADET_PINBALL)
	SignalManager.level_timer_ended.connect(start_boss_fight)
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
	set_boss_as_end(boss)
	enemies.add_child(boss)

func set_boss_as_end(boss: Node2D) -> void:
	var health_comp = boss.get_node_or_null("HealthComponent")
	if health_comp and health_comp.has_signal("died"):
		health_comp.died.connect(boss_death)
	SignalManager.level_won.connect(next_level_reached)

func boss_death() -> void:
	await get_tree().create_timer(1.0).timeout
	SignalManager.level_won.emit()
