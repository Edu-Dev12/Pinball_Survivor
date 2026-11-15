extends EnemyState
class_name EnemyShootState

@export var projectile_scene: PackedScene
@onready var shoot_timer: float = 1.0

func enter() -> void:
	shoot_projectile()

func shoot_projectile() -> void:
	if not projectile_scene or not character: return
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var projectile = projectile_scene.instantiate()
		projectile.global_position = character.global_position
		character.get_parent().add_child(projectile)
		projectile.start_tween_trajectory(player.global_position)
