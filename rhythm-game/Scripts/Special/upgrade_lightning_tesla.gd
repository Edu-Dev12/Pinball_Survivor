extends Special
class_name UpgradeLightningTesla

@export var specialArea: Area2D
@export var expansion_time: float = 1.5 
@export var max_radius: float = 300.0 
@export var lightning_scene: PackedScene
@export var lightning_duration: float = 0.2
@export var damage: float = 10.0

var player: PlayerBody
var rigidBody2D: RigidBody2D

var enemies_hurtbox: Array[HurtboxComponent] = []
var circle_shape: CollisionShape2D

func _ready() -> void:
	for child in specialArea.get_children():
		if child is CollisionShape2D and child.shape is CircleShape2D:
			circle_shape = child
			break

func use_special(playerBody: PlayerBody, rigidBody: RigidBody2D):
	player = playerBody
	rigidBody2D = rigidBody
	
	global_position = rigidBody2D.global_position
	
	shock_wave()

func shock_wave():
	enemies_hurtbox.clear()
	
	if not circle_shape:
		return
		
	circle_shape.shape.radius = 0.0
	
	var tween = create_tween()
	tween.tween_property(circle_shape.shape, "radius", max_radius, expansion_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(_on_expansion_finished)

func _on_expansion_finished():
	enemies_hurtbox = enemies_hurtbox.filter(func(enemy): return is_instance_valid(enemy))
	
	enemies_hurtbox.sort_custom(func(a, b):
		var dist_a = global_position.distance_to(a.global_position)
		var dist_b = global_position.distance_to(b.global_position)
		return dist_a < dist_b
	)
	
	if enemies_hurtbox.is_empty():
		return
		
	var groups: Array[Array] = [[], [], [], [], []]
	var angle_step = (2 * PI) / 5.0
	
	for enemy in enemies_hurtbox:
		var dir = enemy.global_position - global_position
		var angle = dir.angle()
		if angle < 0:
			angle += 2 * PI
			
		var group_index = int(angle / angle_step)
		if group_index >= 5:
			group_index = 4
			
		groups[group_index].append(enemy)
		
	for group in groups:
		if group.is_empty():
			continue
			
		var lightning_line: Line2D
		if lightning_scene:
			lightning_line = lightning_scene.instantiate() as Line2D
		else:
			lightning_line = Line2D.new()
			
		add_child(lightning_line)
		
		lightning_line.position = Vector2.ZERO
		lightning_line.add_point(Vector2.ZERO)
		
		for enemy in group:
			if is_instance_valid(enemy):
				lightning_line.add_point(lightning_line.to_local(enemy.global_position))
				enemy.hurt(damage, null)
			
		var destroy_tween = create_tween()
		destroy_tween.tween_interval(lightning_duration)
		destroy_tween.tween_callback(lightning_line.queue_free)

func _enemies_on_area(area: HurtboxComponent):
	enemies_hurtbox.append(area)
