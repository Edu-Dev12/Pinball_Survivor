extends EnemyState
class_name EnemyChaseState

@export var navigation_component: EnemyNavigationComponent
@export var after_state: State

func enter() -> void:
	if not navigation_component:
		navigation_component = character.get_node_or_null("EnemyNavigationComponent")
	
	if navigation_component:
		if not navigation_component.orbit_reached.is_connected(_on_orbit_reached):
			navigation_component.orbit_reached.connect(_on_orbit_reached)
		navigation_component.find_structure()

func physics_update(delta: float) -> void:
	if navigation_component:
		navigation_component.update_movement(delta)

func _on_orbit_reached() -> void:
	transitioned.emit(self, after_state.name)
