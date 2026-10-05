extends CharacterBody2D

@export var speed: float = 100.0
@export var lifetime: float = 15.0

@onready var sprite_2d: Sprite2D = $Sprite2D

var player: Node2D
var is_dead: bool = false
var tween: Tween

func _ready() -> void:
	add_to_group(Global.ENEMY_GROUP)
	player = get_tree().get_first_node_in_group(Global.PLAYER_GROUP)
	start_countdown()

func _physics_process(_delta: float) -> void:
	if player and not is_dead:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

func start_countdown() -> void:
	tween = create_tween()
	tween.tween_property(sprite_2d, "modulate", Color(1, 0, 0, 1), lifetime)
	tween.tween_callback(explode)

func explode() -> void:
	if is_dead:
		return
	is_dead = true
	queue_free()

func die_by_player() -> void:
	if is_dead:
		return
	is_dead = true
	if tween and tween.is_valid():
		tween.kill()
	queue_free()
