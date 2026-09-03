extends Node2D
class_name LinearVelocityComponent
## Componente responsavel pela velocidade linear da entidade

@export var characterBody2D: CharacterBody2D

func _physics_process(_delta: float) -> void:	
	characterBody2D.move_and_slide()

func stop_movement():
	characterBody2D.velocity = Vector2.ZERO
	
func apply_velocity(direction: Vector2, velocity: float):
	characterBody2D.velocity = direction * velocity
