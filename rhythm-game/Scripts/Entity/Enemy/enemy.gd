extends CharacterBody2D

@export var speed: float = 100.0
var player: Node2D

func _ready() -> void:
	add_to_group(Global.ENEMY_GROUP)
	player = get_tree().get_first_node_in_group("player")

func _physics_process(_delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
