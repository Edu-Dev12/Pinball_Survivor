extends Area2D
class_name BumperAOEComponent

@export var bumper_visual: AnimatedSprite2D
@export var push_strength: float = 500.0 
@export var punch_scale: Vector2 = Vector2(1.5, 1.5)
@export var push_radius: float = 100
@export var tween_duration: float = 0.1

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		trigger_bumper_effect()
		
		var camera = get_tree().get_first_node_in_group(Global.CAMERA_GROUP)
		if camera and camera.has_node("CameraShakeComponent"):
			camera.cameraShakeComponent.trigger_shake()

func trigger_bumper_effect() -> void:
	apply_aoe_push()
	play_punch_tween()

func apply_aoe_push() -> void:
	var all_enemies = get_tree().get_nodes_in_group(Global.ENEMY_GROUP)
	
	for enemy in all_enemies:
		if is_instance_valid(enemy):
			var distance = global_position.distance_to(enemy.global_position)
			if distance <= push_radius:
				var push_dir = global_position.direction_to(enemy.global_position)
				if push_dir == Vector2.ZERO:
					push_dir = Vector2.UP
					
				var final_push = push_dir * push_strength
				var component = enemy.get_node_or_null("EnemyNavigationComponent")
				if component and component.has_method("apply_knockback"):
					component.apply_knockback(final_push)

func play_punch_tween() -> void:
	if not bumper_visual:
		return
	var original_scale = bumper_visual.scale
	var tween = create_tween().set_parallel(false)
	
	tween.tween_property(bumper_visual, "scale", original_scale * punch_scale, tween_duration)
	tween.tween_property(bumper_visual, "scale", original_scale, tween_duration)
