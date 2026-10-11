extends CharacterBody2D

@export var healthComponent: HealthComponent
var player: Node2D

@export var speed: float = 100.0
@export var lifetime: float = 15.0

func _ready() -> void:
	healthComponent.died.connect(_die)
	player = get_tree().get_first_node_in_group(Global.PLAYER_GROUP)

func _physics_process(_delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		
func _die():
	queue_free()
