extends CharacterBody2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box : HitboxComponent = $HitboxComponent

func _ready() -> void:
	if hit_box:
		hit_box.body_entered.connect(_on_hitbox_body_entered)

func start_tween_trajectory(target_position: Vector2) -> void:
	global_rotation = (target_position - global_position).angle()
	var tween = create_tween()
	var distance = global_position.distance_to(target_position)
	var duration = distance / 100.0
	
	tween.tween_property(self, "global_position", target_position, duration)
	tween.tween_callback(projectile_struck)

func _on_hitbox_body_entered(node: Node2D) -> void:
	if node.is_in_group(Global.STRUCTURE_GROUP):
		projectile_struck()

func projectile_struck() -> void:
	if sprite:
		sprite.set_deferred("visible", false)
	if hit_box and hit_box.get_child_count() > 0:
		hit_box.get_child(0).set_deferred("disabled", true)
	queue_free()
