extends EnemyState
class_name RunOver

@export var after_idle_state: State
@export var run_over_duration: float = 10.0 

var direction: Vector2 = Vector2.ZERO
var attack_time: float = 0.0
var target: StaticBody2D

func enter() -> void:
	if animated_sprite:
		if not animated_sprite.is_playing() or animated_sprite.animation != "Fighting":
			animated_sprite.play("Fighting")
	attack_time = run_over_duration
	
	find_structure()
	if target:
		direction = (target.global_position - character.global_position).normalized()
	else:
		direction = Vector2(1, 1).normalized()

func physics_update(delta: float) -> void:
	if not character: return
	
	character.velocity = direction * character.speed
	var collide = character.move_and_slide()
	
	if collide and character.get_slide_collision_count() > 0:
		var collision = character.get_slide_collision(0)
		var normal = collision.get_normal()
		
		direction = direction.bounce(normal).normalized()

	attack_time -= delta
	if attack_time <= 0:
		transitioned.emit(self, after_idle_state.name)

func find_structure() -> void:
	var structure_list = get_tree().get_nodes_in_group(Global.STRUCTURE_GROUP)
	
	if structure_list.size() > 0:
		target = structure_list.pick_random() as Node2D
