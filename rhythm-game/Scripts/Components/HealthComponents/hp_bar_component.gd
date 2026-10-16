extends ProgressBar
class_name HPBarComponent

@export var health_component: HealthComponent

func _ready() -> void:
	if health_component:
		health_component.health_changed.connect(_on_health_changed)
		_on_health_changed(health_component.current_health, health_component.max_health)

func _on_health_changed(current_health: int, max_health: int) -> void:
	if max_health > 0:
		self.value = (float(current_health) / float(max_health)) * 100.0
