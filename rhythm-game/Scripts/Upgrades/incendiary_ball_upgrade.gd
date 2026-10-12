extends Node2D
class_name IncendiaryBallUpgrade

@export var trail_damage: int = 1
@export var trail_lifetime: float = 1.0
@export var trail_range: float = 5.0
@export var spawn_distance_interval: float = 30.0

@export_flags_2d_physics var trail_collision_mask: int = 0

@export var shrink_over_time: bool = false
@export var shrink_transition_type: Tween.TransitionType = Tween.TRANS_LINEAR

@export var player: RigidBody2D

var last_spawn_position: Vector2

func _ready() -> void:
	if player:
		last_spawn_position = player.global_position

func _physics_process(_delta: float) -> void:
	if not player: return
	
	var current_position: Vector2 = player.global_position
	var distance_travelled: float = current_position.distance_to(last_spawn_position)
	
	if distance_travelled >= spawn_distance_interval:
		spawn_trail(current_position)
		last_spawn_position = current_position

func spawn_trail(spawn_position: Vector2) -> void:
	var area_instance = HitOverTimeAreaComponent.new()
	area_instance.damage = trail_damage
	area_instance.lifetime = trail_lifetime
	area_instance.collision_mask = trail_collision_mask
	
	area_instance.shrink_over_time = shrink_over_time
	area_instance.shrink_transition_type = shrink_transition_type
	
	var collision_shape = CollisionShape2D.new()
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = trail_range
	collision_shape.shape = circle_shape
	area_instance.add_child(collision_shape)
	
	get_tree().current_scene.add_child(area_instance)
	area_instance.global_position = spawn_position
