extends Line2D
#class_name TrajectoryPredictor
#
#@export var ball_rigidbody: RigidBody2D
#@export var input_controller: InputControllerComponent
#@export var flipper_hit: FlipperHitComponent
#
#func _ready() -> void:
	#top_level = true
	#visible = false
#
#func _physics_process(_delta: float) -> void:
	#if not ball_rigidbody or not input_controller or not flipper_hit:
		#return
		#
	#var input_direction = input_controller.get_input()
	#
	#if input_direction != Vector2.ZERO:
		#visible = true
		#global_position = ball_rigidbody.global_position
		#
		#var buffered_dir: Vector2 = input_controller.get_attack_direction()
		#var dir_norm: Vector2 = buffered_dir.normalized()
		#
		#var hit_force: float = flipper_hit.hit_force
		#
		#var line_length: float = remap(hit_force, flipper_hit.hit_min_charge, flipper_hit.hit_max_charge, 20.0, 150.0)
		#line_length = clamp(line_length, 20.0, 180.0)
		#
		#var start_point: Vector2 = Vector2.ZERO
		#var end_point: Vector2 = dir_norm * line_length
		#
		#points = [start_point, end_point]
	#else:
		#visible = false
