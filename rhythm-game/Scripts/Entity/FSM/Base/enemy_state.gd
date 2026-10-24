extends State
class_name EnemyState

@onready var character: CharacterBody2D
@onready var animated_sprite: AnimatedSprite2D

func _ready() -> void:
	character = owner as CharacterBody2D
	if character:
		animated_sprite = character.get_node_or_null("AnimatedSprite2D")
