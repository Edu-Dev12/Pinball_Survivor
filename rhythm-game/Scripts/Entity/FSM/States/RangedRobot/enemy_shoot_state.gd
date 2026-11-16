extends EnemyState
class_name EnemyShootState

const projectile_scene: PackedScene = preload("uid://c5vhcbswc1tbw")
@export var navigation_component : EnemyNavigationComponent
@export var shoot_timer_interval: float = 5.0

func enter() -> void:
	shoot_projectile()

func shoot_projectile() -> void:
	if not projectile_scene or not character: return
	if navigation_component.target:
		var projectile = projectile_scene.instantiate()
		projectile.global_position = character.global_position
		character.get_parent().add_child(projectile)
		projectile.start_tween_trajectory(navigation_component.target.global_position)
		get_tree().create_timer(shoot_timer_interval, true, false, true).timeout.connect(shoot_projectile)
