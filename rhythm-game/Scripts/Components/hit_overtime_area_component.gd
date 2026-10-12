extends HitboxComponent
class_name HitOverTimeAreaComponent

@export var damage_interval: float = 0.5
@export var lifetime: float = 3.0

@export var shrink_over_time: bool = false
@export var shrink_transition_type: Tween.TransitionType = Tween.TRANS_LINEAR

var areas_inside: Array[HurtboxComponent] = []
var damage_timer: Timer
var lifetime_timer: Timer

func _ready() -> void:
	area_entered.connect(_on_area_entered_over_time)
	area_exited.connect(_on_area_exited_over_time)
	setup_timers()
	if shrink_over_time:
		setup_shrink_tween()

func setup_timers() -> void:
	damage_timer = Timer.new()
	damage_timer.wait_time = damage_interval
	damage_timer.autostart = false
	damage_timer.timeout.connect(_on_damage_timer_timeout)
	add_child(damage_timer)
	
	lifetime_timer = Timer.new()
	lifetime_timer.wait_time = lifetime
	lifetime_timer.one_shot = true
	lifetime_timer.timeout.connect(_on_lifetime_timeout)
	add_child(lifetime_timer)
	lifetime_timer.start()

func setup_shrink_tween() -> void:
	var tween = create_tween()
	tween.set_trans(shrink_transition_type)
	tween.tween_property(self, "scale", Vector2.ZERO, lifetime)

func _on_area_entered_over_time(area: Area2D) -> void:
	if area is HurtboxComponent:
		var hurtbox = area as HurtboxComponent
		if not areas_inside.has(hurtbox):
			areas_inside.append(hurtbox)
			hurtbox.hurt(damage, self)
			hit.emit()
			if damage_timer.is_stopped():
				damage_timer.start()

func _on_area_exited_over_time(area: Area2D) -> void:
	if area is HurtboxComponent:
		areas_inside.erase(area as HurtboxComponent)
		if areas_inside.is_empty():
			damage_timer.stop()

func _on_damage_timer_timeout() -> void:
	for hurtbox in areas_inside:
		if is_instance_valid(hurtbox):
			hurtbox.hurt(damage, self)
			hit.emit()

func _on_lifetime_timeout() -> void:
	var collision_shape = get_node_or_null("CollisionShape2D")
	if collision_shape:
		collision_shape.set_deferred("disabled", true)
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(queue_free)
