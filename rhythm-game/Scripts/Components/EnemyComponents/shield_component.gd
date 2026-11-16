extends HurtboxComponent
class_name ShieldComponent

@export var hurtbox: HurtboxComponent

func _ready() -> void:
	hurtbox.is_active = false

func hurt(_damage: int, _hitbox: HitboxComponent) -> void:
	set_active_state(false)

func set_active_state(state: bool) -> void:
	if state:
		$ColorRect.visible = true
		hurtbox.set_active_state(false)
	else:
		$ColorRect.visible = false
		await get_tree().create_timer(0.5, true, false, true).timeout
		hurtbox.set_active_state(true)
