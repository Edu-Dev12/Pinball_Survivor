extends CharacterBody2D

@export var healthComponent: HealthComponent
var target: Node2D

var structure_list: Array

@export var speed: float = 100.0
@export var lifetime: float = 15.0

func _ready() -> void:
	healthComponent.died.connect(_die)
	
	structure_list = get_tree().get_nodes_in_group(Global.STRUCTURE_GROUP)
	
	if structure_list.size() > 0:
		target = structure_list.pick_random() as Node2D

func _physics_process(_delta: float) -> void:
	if target and is_instance_valid(target):
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		
func _die():
	queue_free()
