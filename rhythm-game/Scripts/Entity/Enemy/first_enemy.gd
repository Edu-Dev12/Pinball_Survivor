extends CharacterBody2D

@export var animatedSprite2D: AnimatedSprite2D

func _physics_process(_delta: float) -> void:
		if animatedSprite2D:
			animatedSprite2D.flip_h = velocity.x >= 0
		
