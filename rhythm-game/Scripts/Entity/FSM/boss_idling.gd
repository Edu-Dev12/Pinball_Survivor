extends EnemyState
class_name BossIdling

@export var after_idle_state: State

func enter() -> void:
	if animated_sprite:
		if not animated_sprite.is_playing() or animated_sprite.animation != "Idling":
			animated_sprite.play("Idling")

func start_boss_fight() -> void:
		transitioned.emit(self, after_idle_state.name) 
