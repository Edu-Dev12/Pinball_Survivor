extends EnemyState
class_name EnemyChaseState

@export var after_state: State
@export var navigation_component: EnemyNavigationComponent
@export var permanent_chase: bool = false

func enter() -> void:
	if navigation_component:
		navigation_component.stop()
		if not permanent_chase:
			if not navigation_component.orbit_reached.is_connected(_on_orbit_reached):
				navigation_component.orbit_reached.connect(_on_orbit_reached)
		navigation_component.start()
	connect_target_death()

func physics_update(delta: float) -> void:
	if navigation_component:
		navigation_component.update_movement(delta)

func exit() -> void:
	if navigation_component and navigation_component.orbit_reached.is_connected(_on_orbit_reached):
		navigation_component.orbit_reached.disconnect(_on_orbit_reached)
	character.velocity = Vector2.ZERO
	navigation_component.stop()

func connect_target_death() -> void:
	var component = navigation_component.target.get_node_or_null("HealthComponent")
	if component and component.has_signal("died"):
		component.died.connect(redirect)

func redirect() -> void:
	character.velocity = Vector2.ZERO
	navigation_component.stop()
	navigation_component.start()

func _on_orbit_reached() -> void:
	transitioned.emit(self, after_state.name)
