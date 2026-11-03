extends Marker2D
class_name BossSpawner

@export var boss_to_spawn : PackedScene

func start_boss_fight() -> void:
	boss_spawn()

func boss_spawn() -> void:
	if not boss_to_spawn:
		return
	var boss = boss_to_spawn.instantiate()
	boss.global_position = self.global_position
	set_boss_as_end(boss)
	get_parent().add_child(boss)

func set_boss_as_end(boss: Node2D) -> void:
	var health_comp = boss.get_node_or_null("HealthComponent")
	if health_comp and health_comp.has_signal("died"):
		health_comp.died.connect(boss_death)

func boss_death() -> void:
	await get_tree().create_timer(1.0).timeout
	SignalManager.level_won.emit()
