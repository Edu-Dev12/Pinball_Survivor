extends Node
class_name RebounceBehaviorComponent

@export var rebounce_force: float = 120.0
@export var speed_limit: float = 1000.0
@export var speed_slowdown_rate: float = 1.1

@export var source: Node2D
@export var target: RigidBody2D
@export var hurt_box_component: HurtboxComponent

func _ready() -> void:
	if hurt_box_component:
		hurt_box_component.was_hurt.connect(_on_was_hurt)
	
	if not target:
		target = get_tree().get_first_node_in_group(Global.PLAYER_GROUP) as RigidBody2D

func _on_was_hurt(hitbox: HitboxComponent) -> void:
	if !hitbox.apply_ball_bounce:
		return
	
	if not target or not source: return
	
	var current_speed: float = target.linear_velocity.length()
	
	if current_speed < speed_limit:
		apply_normal_rebounce(current_speed)
	else:
		execute_strong_impact()

func apply_normal_rebounce(current_speed: float) -> void:
	var escape_direction: Vector2 = (target.global_position - source.global_position).normalized()
	var final_speed: float = current_speed + rebounce_force
	target.linear_velocity = escape_direction * final_speed

func execute_strong_impact() -> void:
	TimeManager.slow_motion(0.2, 0.2)
	target.linear_velocity = target.linear_velocity / speed_slowdown_rate
	
	var camera = get_tree().get_first_node_in_group(Global.CAMERA_GROUP)
	if camera and camera.has_node("CameraShakeComponent"):
		camera.cameraShakeComponent.trigger_shake()
